# frozen_string_literal: true

module ThemeCreator
  module ExtraLocalesControllerExtension
    extend ActiveSupport::Concern

    def show
      bundle = params[:bundle]

      if params[:v]&.size == 32
        hash = ExtraLocalesController.bundle_js_hash(bundle)
        immutable_for(24.hours) if hash == params[:v]
      end

      render plain: ExtraLocalesController.bundle_js(bundle), content_type: "application/javascript"
    end
  end
end
