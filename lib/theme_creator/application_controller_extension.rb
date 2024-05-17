# frozen_string_literal: true

module ThemeCreator
  module ApplicationControllerExtension
    extend ActiveSupport::Concern

    # Allow preview of shared user themes
    # flash[:user_theme_id] will only be populated after a POST request
    # after a UI confirmation (theme_creator_controller.rb) to prevent hotlinking
    def handle_theme
      super
      user_theme_id = flash[:user_theme_id]
      if user_theme_id && Theme.theme_ids.include?(user_theme_id) && # Has requested a valid theme
           guardian.can_see_user_theme?(Theme.find_by(id: user_theme_id))
        @theme_id = request.env[:resolved_theme_id] = user_theme_id
      end
    end
  end
end
