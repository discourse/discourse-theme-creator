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
  get 'u/:username/themes/:id/:target/:field_name/edit' => 'users#index', constraints: { username: RouteFormat.username }
end

after_initialize do
  add_to_class(:guardian, :allow_theme?) do |theme_key|
    if is_staff?
      Theme.theme_keys.include?(theme_key)
    else
      Theme.user_theme_keys.include?(theme_key) || Theme.where("user_id = ?", @user.id).pluck(:key).include?(theme_key)
    end
  end
end


