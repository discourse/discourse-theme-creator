# frozen_string_literal: true

module ::ThemeCreator
  PLUGIN_NAME = "discourse-theme-creator"

  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace ThemeCreator
  end
end
