# frozen_string_literal: true

class BasicUserThemeSerializer < ApplicationSerializer
  attributes :id, :name, :color_scheme
  has_one :user, serializer: UserNameSerializer, embed: :object
end
