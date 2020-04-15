# frozen_string_literal: true

module ::ThemeCreator
  class Engine < ::Rails::Engine
    engine_name "theme_creator"
    isolate_namespace ThemeCreator
  end
end
