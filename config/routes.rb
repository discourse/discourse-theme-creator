ThemeCreator::Engine.routes.draw do
  get "" => "theme_creator#list"
  post "" => "theme_creator#create"
  delete ":id" => "theme_creator#destroy"
  put ":id" => "theme_creator#update"
  get ":id/preview" => "theme_creator#preview"
  post ":id/colors" => "theme_creator#create_color_scheme"
  put ":id/colors/:color_scheme_id" => "theme_creator#update_color_scheme"
end
