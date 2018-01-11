ThemeCreator::Engine.routes.draw do
  get "user_themes" => "theme_creator#list"
  post "user_themes" => "theme_creator#create"
  delete "user_themes/:id" => "theme_creator#destroy"
  put "user_themes/:id" => "theme_creator#update"
  get "user_themes/:id/preview" => "theme_creator#preview"
end
