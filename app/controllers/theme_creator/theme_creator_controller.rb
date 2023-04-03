# frozen_string_literal: true

# We're going to extend the admin theme controller, so we don't repeat all the logic there

class ThemeCreator::ThemeCreatorController < Admin::ThemesController
  requires_login(nil) # Override the blanket "require logged in" from the admin controller
  skip_before_action :ensure_admin

  before_action :ensure_logged_in, except: %i[preview share_preview share_info]

  before_action :ensure_own_theme,
                only: %i[
                  show
                  export
                  destroy
                  update
                  create_color_scheme
                  update_color_scheme
                  destroy_color_scheme
                  update_single_setting
                ]

  skip_before_action :check_xhr, only: %i[share_info preview share_preview]

  def fetch_api_key
    client_id = "theme_cli_#{current_user.id}"

    UserApiKey.where(user_id: current_user.id, client_id: client_id).destroy_all
    api_key =
      UserApiKey.create!(
        application_name: I18n.t("theme_creator.api_application_name"),
        client_id: client_id,
        user_id: current_user.id,
        scopes: [UserApiKeyScope.new(name: "discourse-theme-creator:user_themes")],
      )

    render json: { api_key: api_key.key }
  end

  # Preview is used when actively developing a theme, it uses the GET parameter ?preview_theme_id
  def preview
    @theme ||= Theme.find(params[:id])
    raise Discourse::InvalidAccess.new() if !guardian.can_hotlink_user_theme?(@theme)

    redirect_to path("/?preview_theme_id=#{@theme.id}")
  end

  # Shared preview is used when sharing the theme with others. It is only accessible via POST to avoid
  # hotlinking (reduce XSS risk)
  def share_preview
    @theme ||= Theme.find(params[:id])
    raise Discourse::InvalidAccess.new() if !guardian.can_see_user_theme?(@theme)

    dest_path = "/"

    if @theme.share_destination
      parsed =
        begin
          URI.parse(@theme.share_destination)
        rescue URI::Error
        end

      if parsed && (parsed.host == nil || parsed.host == Discourse.current_hostname)
        dest_path = +"#{parsed.path}"
        dest_path << "?#{parsed.query}" if parsed.query
      end
    end

    redirect_to path(dest_path), flash: { user_theme_id: @theme.id }
  end

  def share_info
    if params[:theme_id]
      @theme ||= Theme.find(params[:theme_id])
    else
      raise Discourse::NotFound unless theme_owner = User.find_by_username(params[:username])

      result =
        PluginStoreRow
          .where(plugin_name: "discourse-theme-creator")
          .where("key LIKE ?", "share:#{theme_owner.id}:%")
          .where(value: params[:slug])

      raise Discourse::InvalidAccess.new() if !result.any?

      psr = result.first

      theme_id = psr.key.remove("share:#{theme_owner.id}:").to_i

      @theme ||= Theme.find(theme_id)
    end

    raise Discourse::InvalidAccess.new() if !guardian.can_see_user_theme?(@theme)

    respond_to do |format|
      format.html { render :share_info }

      format.json { render json: @theme, serializer: ::BasicUserThemeSerializer, root: "theme" }
    end
  end

  def list
    @theme =
      Theme
        .where(user_id: theme_user.id)
        .order(:name)
        .includes(
          :child_themes,
          :parent_themes,
          :remote_theme,
          :theme_settings,
          :settings_field,
          :locale_fields,
          :user,
          :color_scheme,
          theme_fields: :upload,
        )

    # Only present color schemes that are attached to the user's themes
    @color_schemes =
      ColorScheme
        .where(theme_id: @theme.map(&:id))
        .includes(color_scheme_colors: :color_scheme)
        .to_a
    light = ColorScheme.new(name: I18n.t("color_schemes.light"))
    @color_schemes.unshift(light)

    payload = {
      user_themes: ActiveModel::ArraySerializer.new(@theme, each_serializer: ThemeSerializer),
      extras: {
        color_schemes:
          ActiveModel::ArraySerializer.new(@color_schemes, each_serializer: ColorSchemeSerializer),
      },
    }

    respond_to { |format| format.json { render json: payload } }
  end

  # def create # Implemented in Admin::ThemesController

  # Mostly using default implementation, but add a security check so users
  # can only set the color scheme to one owned by the current theme
  def update
    @theme ||= Theme.find(params[:id])

    # Set the user_theme specific fields
    %i[share_slug share_destination].each do |field|
      @theme.send("#{field}=", theme_params[field]) if theme_params.key?(field)
    end

    # Set the user_theme specific fields
    %i[
      about_url
      license_url
      theme_version
      authors
      minimum_discourse_version
      maximum_discourse_version
    ].each do |field|
      if theme_params[:remote_theme]&.key?(field)
        @theme.build_remote_theme(remote_url: "") unless @theme.remote_theme
        @theme.remote_theme.send("#{field}=", theme_params[:remote_theme][field])
        @theme.remote_theme.save!
      end
    end

    # Check color scheme permission
    if theme_params.key?(:color_scheme_id) && !theme_params[:color_scheme_id].nil?
      color_scheme = ColorScheme.find(theme_params[:color_scheme_id])
      if color_scheme.theme_id != @theme.id
        raise Discourse::InvalidAccess.new("Color scheme must be owned by theme.")
      end
    end

    super
  end

  # def create # Implemented in Admin::ThemesController

  def create_color_scheme
    @theme ||= Theme.find(params[:id])

    new_scheme = ColorScheme.create_from_base(name: I18n.t("theme_creator.new_color_scheme"))
    new_scheme.theme_id = @theme.id
    new_scheme.save!

    @theme.color_scheme_id = new_scheme.id
    @theme.save!

    respond_to { |format| format.json { head :no_content } }
  end

  def update_color_scheme
    @theme ||= Theme.find(params[:id])
    @color_scheme = ColorScheme.find(params[:color_scheme_id])

    # The theme ID has been validated, so just check that this color scheme
    # really does belong to the theme
    if @color_scheme.theme_id != @theme.id
      raise Discourse::InvalidAccess.new("Cannot modify that color scheme.")
    end

    color_scheme_params = params.permit(color_scheme: [:name, colors: %i[name hex]])[:color_scheme]

    color_scheme = ColorSchemeRevisor.revise(@color_scheme, color_scheme_params)
    if color_scheme.valid?
      render json: color_scheme, root: false
    else
      render_json_error(color_scheme)
    end
  end

  def destroy_color_scheme
    @theme ||= Theme.find(params[:id])
    @color_scheme = ColorScheme.find(params[:color_scheme_id])

    # The theme ID has been validated, so just check that this color scheme
    # really does belong to the theme
    if @color_scheme.theme_id != @theme.id
      raise Discourse::InvalidAccess.new("Cannot modify that color scheme.")
    end

    if @theme.color_scheme_id == @color_scheme.id
      @theme.color_scheme_id = nil
      @theme.save!
    end

    @color_scheme.destroy

    respond_to { |format| format.json { head :no_content } }
  end

  def ban_for_remote_theme!
    # no-op - we want to allow this stuff for theme-creator
  end

  private

  # Override with a restricted version
  # Users shouldn't be able to modify:
  #  - :default and :user_selectable
  #  - :child_theme_ids
  # But we want to add
  #  - is_shared
  #  - share_slug
  def theme_params
    @theme_params ||=
      begin
        params.require(:theme).permit(
          :name,
          :share_slug,
          :share_destination,
          :color_scheme_id,
          # :default,
          # :user_selectable,
          :component,
          settings: {
          },
          translations: {
          },
          remote_theme: {
          },
          theme_fields: %i[name target value upload_id type_id],
          # child_theme_ids: []
        )
      end
  end

  def ensure_own_theme
    @theme = Theme.find(params[:id])
    if !(@theme.user_id == current_user.id || current_user.staff?)
      raise Discourse::InvalidAccess.new("Cannot modify another user's theme.")
    end
  end

  def ensure_can_see_user_theme
    @theme = Theme.find(params[:id])
    raise Discourse::InvalidAccess.new() if !guardian.can_see_user_theme?(@theme)
  end

  def theme_user
    user_id =
      params[:user_id] || (params[:theme] && params[:theme].try(:[], :user_id)) || current_user.id
    unless (user_id.to_i == current_user.id) || current_user.staff?
      raise Discourse::InvalidAccess.new()
    end
    User.find(user_id)
  end
end
