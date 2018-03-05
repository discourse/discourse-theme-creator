ThemeCreator::Engine.routes.draw do
  get "user_themes" => "theme_creator#list"
  post "user_themes" => "theme_creator#create"
  delete "user_themes/:id" => "theme_creator#destroy"
  put "user_themes/:id" => "theme_creator#update"
  get "user_themes/:id/preview" => "theme_creator#preview"
  post "user_themes/:id/colors" => "theme_creator#create_color_scheme"
  put "user_themes/:id/colors/:color_scheme_id" => "theme_creator#update_color_scheme"
end
