Discourse::Application.routes.append do
  mount ::ThemeCreator::Engine, at: "/user_themes"
  get "theme/:theme_id" => "theme_creator/theme_creator#share_info"
  get "theme/:username/:slug" => "theme_creator/theme_creator#share_info", constraints: { username: RouteFormat.username }
  get "u/:username/themes" => "users#index", constraints: { username: RouteFormat.username }
  get "u/:username/themes/:id" => "users#index", constraints: { username: RouteFormat.username }
  get "u/:username/themes/:theme_id/colors/:color_scheme_id" => "users#index", constraints: { username: RouteFormat.username }
  get 'u/:username/themes/:id/:target/:field_name/edit' => 'users#index', constraints: { username: RouteFormat.username }
end

ThemeCreator::Engine.routes.draw do
  # Theme CRUD
  get "(.:format)" => "theme_creator#list"
  post "" => "theme_creator#create"
  get ":id" => "theme_creator#show"
  delete ":id" => "theme_creator#destroy"
  put ":id" => "theme_creator#update"
  get ":id/preview" => "theme_creator#preview"
  get ":id/export" => "theme_creator#export"

  # Additional theme endpoints
  post "upload_asset" => "theme_creator#upload_asset"
  post "import" => "theme_creator#import"
  post "generate_key_pair" => "theme_creator#generate_key_pair"

  # Access user_api_key for Theme CLI
  post "fetch_api_key" => "theme_creator#fetch_api_key"

  # Sharing with other users
  post ":id/view" => "theme_creator#share_preview"

  # Color scheme
  post ":id/colors" => "theme_creator#create_color_scheme"
  put ":id/colors/:color_scheme_id" => "theme_creator#update_color_scheme"
  delete ":id/colors/:color_scheme_id" => "theme_creator#destroy_color_scheme"
end
