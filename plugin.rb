# name: discourse-theme-creator
# about: Allows users to create and share their own themes.
# version: 0.1
# author: David Taylor dtaylor.uk
# url: https://www.github.com/davidtaylorhq/discourse-theme-creator

register_asset 'theme_creator.js'
register_asset "stylesheets/theme-creator.scss"

load File.expand_path('../lib/theme_creator/engine.rb', __FILE__)

Discourse::Application.routes.append do
  mount ::ThemeCreator::Engine, at: "/theme-creator"
  get "u/:username/themes" => "users#index", constraints: { username: RouteFormat.username }
  get "u/:username/themes/:id" => "users#index", constraints: { username: RouteFormat.username }
  get "u/:username/themes/:theme_id/colors/:color_scheme_id" => "users#index", constraints: { username: RouteFormat.username }
  get 'u/:username/themes/:id/:target/:field_name/edit' => 'users#index', constraints: { username: RouteFormat.username }
end

after_initialize do

  # Override guardian to allow using themes that are not 'user selectable'
  add_to_class(:guardian, :allow_theme?) do |theme_key|
    return true if Theme.user_theme_keys.include?(theme_key) # Default implementation

    return false if not Theme.theme_keys.include?(theme_key) # Is not a valid theme

    can_see_user_theme? Theme.find_by(key: theme_key)
  end

  add_to_class(:guardian, :can_see_user_theme?) do |theme|
    return true if is_staff?

    return true if is_my_own?(theme)

    # Theme is shared and theme owner has permission to share
    theme.is_shared && User.find(theme.user_id).guardian.can_share_user_theme?(theme)
  end

  add_to_class(:guardian, :can_edit_user_theme?) do |theme|
    is_staff? || is_my_own?(theme)
  end

  add_to_class(:guardian, :can_share_user_theme?) do |theme|
    return true if SiteSetting.theme_creator_share_groups.blank? # all users can share

    # Check if user is in any allowed groups
    allowed_groups = SiteSetting.theme_creator_share_groups.split("|")
    @user.groups.where(name: allowed_groups).exists?
  end

  # Add methods so that a theme can be shared/unshared by the user
  add_to_class(:theme, :is_shared) do 
    PluginStore.get('discourse-theme-creator', "share:$#{id}") == true
  end

  add_to_class(:theme, :is_shared=) do |val|
    PluginStore.set('discourse-theme-creator', "share:$#{id}", val==true)
  end

  add_to_serializer(:theme, :is_shared) do
    object.is_shared
  end

  add_to_serializer(:theme, :can_share) do
    User.find(object.user_id).guardian.can_share_user_theme?(object)
  end

end


