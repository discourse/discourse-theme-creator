ThemeCreator::Engine.routes.draw do
  # Theme CRUD
  get "" => "theme_creator#list"
  post "" => "theme_creator#create"
  delete ":id" => "theme_creator#destroy"
  put ":id" => "theme_creator#update"
  get ":id/preview" => "theme_creator#preview"

  # Additional theme endpoints
  post "upload_asset" => "theme_creator#upload_asset"

  # Sharing with other users
  get ":id/view" => "theme_creator#share_info"
  post ":id/view" => "theme_creator#share_preview"

  # Color scheme
  post ":id/colors" => "theme_creator#create_color_scheme"
  put ":id/colors/:color_scheme_id" => "theme_creator#update_color_scheme"
  delete ":id/colors/:color_scheme_id" => "theme_creator#destroy_color_scheme"  
end
