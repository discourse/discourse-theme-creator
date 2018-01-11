class ThemeCreator::ThemeCreatorController < ApplicationController

  before_action :ensure_logged_in

  before_action :ensure_own_theme, only: [:destroy, :update, :preview]
  skip_before_action :check_xhr, only: [:preview]

  def preview
    @theme = Theme.find(params[:id])

    redirect_to path("/"), flash: { preview_theme_key: @theme.key }
  end

  def list
    @theme = Theme.where(user_id: current_user.id).order(:name).includes(:theme_fields, :remote_theme)
    @color_schemes = ColorScheme.all.to_a
    light = ColorScheme.new(name: I18n.t("color_schemes.default"))
    @color_schemes.unshift(light)

    payload = {
      user_themes: ActiveModel::ArraySerializer.new(@theme, each_serializer: ThemeSerializer),
      extras: {
        color_schemes: ActiveModel::ArraySerializer.new(@color_schemes, each_serializer: ColorSchemeSerializer)
      }
    }

    respond_to do |format|
      format.json { render json: payload }
    end
  end

  def create
    @theme = Theme.new(name: theme_params[:name],
                       user_id: current_user.id,
                       user_selectable: false,)

    respond_to do |format|
      if @theme.save
        format.json { render json: { user_theme: @theme }, status: :created }
      else
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @theme = Theme.find(params[:id])

    [:name].each do |field|
      if theme_params.key?(field)
        @theme.send("#{field}=", theme_params[field])
      end
    end

    set_fields

    respond_to do |format|
      if @theme.save
        format.json { render json: { user_theme: @theme }, status: :created }
      else
        format.json {
          error = @theme.errors[:color_scheme] ? I18n.t("themes.bad_color_scheme") : I18n.t("themes.other_error")
          render json: { errors: [ error ] }, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

    def theme_params
      @theme_params ||=
        begin
          # deep munge is a train wreck, work around it for now
          params[:user_theme][:child_theme_ids] ||= [] if params[:user_theme].key?(:child_theme_ids)

          params.require(:user_theme).permit(
            :name,
            # :color_scheme_id,
            # :default,
            # :user_selectable,
            theme_fields: [:name, :target, :value, :upload_id, :type_id],
            # child_theme_ids: []
          )
        end
    end

    def set_fields
      return unless fields = theme_params[:theme_fields]

      fields.each do |field|
        if field[:target] == 'common' && field[:name] == 'scss'
          @theme.set_field(
            target: field[:target],
            name: field[:name],
            value: field[:value],
            # type_id: field[:type_id],
            # upload_id: field[:upload_id]
          )
        end
      end
    end

    def ensure_own_theme
      @theme = Theme.find(params[:id])
      if @theme.user_id != current_user.id
        raise Discourse::InvalidAccess.new("Cannot modify another user's theme.")
      end
    end

end
