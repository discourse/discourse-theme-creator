# frozen_string_literal: true

module ThemeCreator
  module ApplicationHelperExtension
    extend ActiveSupport::Concern

    def client_side_setup_data
      super.merge(is_staff: true)
    end
  end
end
