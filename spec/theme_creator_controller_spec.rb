require 'rails_helper'

RSpec.describe "Theme Creator Controller", type: :request do
  let(:user1) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }
  let(:theme) { Theme.create!(name: "My New Theme", user_id: user1.id) }

  describe 'preview' do
    it "fails to hotlink other users themes" do
      get "/user_themes/#{theme.id}/preview"
      expect(response).to have_http_status(403)
    end

    it "allows hotlinking own themes" do
      sign_in(user1)
      get "/user_themes/#{theme.id}/preview"
      expect(response).to have_http_status(302)
    end
  end

  describe 'share_preview' do
    it "fails to preview other users themes" do
      post "/user_themes/#{theme.id}/view"
      expect(response).to have_http_status(403)
    end

    it "previews own themes" do
      sign_in(user1)
      post "/user_themes/#{theme.id}/view"
      expect(response).to have_http_status(302)
    end

    it "previews shared themes" do
      SiteSetting.theme_creator_share_groups = ''
      theme.is_shared = true
      theme.save!
      post "/user_themes/#{theme.id}/view"
      expect(response).to have_http_status(302)
    end
  end

  describe 'share_info' do
    it "only reveals info for shared themes" do
      get "/user_themes/#{theme.id}/view.json"
      expect(response).to have_http_status(403)

      theme.is_shared = true
      theme.save!
      SiteSetting.theme_creator_share_groups = ''

      get "/user_themes/#{theme.id}/view.json"
      expect(response).to have_http_status(200)
    end
  end

  # TODO: More functionality tests

end
