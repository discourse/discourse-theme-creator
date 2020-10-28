class UpdateUserApiKeyScopes < ActiveRecord::Migration[6.0]
  def change
    execute <<~SQL
      UPDATE user_api_key_scopes
      SET name = 'discourse-theme-creator:user_themes'
      WHERE name = 'user_themes'
    SQL
  end
end
