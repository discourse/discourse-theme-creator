require 'rails_helper'

RSpec.describe "Theme Creator Controller", type: :request do
  let(:user1) { Fabricate(:user) }
  let(:user2) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }
  let(:theme) { Theme.create!(name: "My New Theme", user_id: user1.id) }
  let(:color_scheme) { ColorScheme.create!(name: "My Color Scheme", theme_id: theme.id) }

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

    it "allows previewing shared themes" do
      SiteSetting.theme_creator_share_groups = ''
      theme.share_slug = 'mytheme'
      theme.save!

      post "/user_themes/#{theme.id}/view"
      expect(response).to have_http_status(302)
    end
  end

  describe 'share_info' do
    it "only reveals info for shared themes" do
      SiteSetting.theme_creator_share_groups = 'staff'
      theme.share_slug = 'mytheme'

      get "/theme/#{user1.username}/#{theme.share_slug}.json"
      expect(response).to have_http_status(403)

      SiteSetting.theme_creator_share_groups = ''
      get "/theme/#{user1.username}/#{theme.share_slug}.json"
      expect(response).to have_http_status(200)

      get "/theme/user-not-found/#{theme.share_slug}.json"
      expect(response).to have_http_status(404)

      get '/theme/theme-not-found.json'
      expect(response).to have_http_status(404)
    end
  end

  describe 'show' do
    it "fails to download other users themes" do
      get "/user_themes/#{theme.id}"
      expect(response).to have_http_status(403)
    end

    it "downloads own themes" do
      sign_in(user1)
      get "/user_themes/#{theme.id}"
      expect(response).to have_http_status(200)
    end

    it "allows downloading shared themes" do
      SiteSetting.theme_creator_share_groups = ''
      theme.share_slug = 'mytheme'
      theme.save!

      get "/user_themes/#{theme.id}"
      expect(response).to have_http_status(200)
    end
  end

  describe 'crud' do
    context 'logged in as user 2' do
      before do
        sign_in(user2)
      end

      it 'fails to delete theme owned by user 1' do
        delete "/user_themes/#{theme.id}.json"
        expect(response).to have_http_status(403)
      end

      it 'fails to update theme owned by user 1' do
        put "/user_themes/#{theme.id}.json", params: {
          theme: {
            name: "New Theme Title"
          }
        }
        expect(response).to have_http_status(403)
        theme.reload
        expect(theme.name).to eq("My New Theme")
      end

      it 'fails to create color scheme for theme owned by user 1' do
        post "/user_themes/#{theme.id}/colors.json"
        expect(response).to have_http_status(403)
      end

      it 'fails to edit color scheme for theme owned by user 1' do
        put "/user_themes/#{theme.id}/colors/#{color_scheme.id}.json", params: {
          color_scheme: {
            name: "Some New Name"
          }
        }
        expect(response).to have_http_status(403)
        color_scheme.reload
        expect(color_scheme.name).to eq("My Color Scheme")
      end

      it "fails to delete color scheme for theme owned by user 1" do
        delete "/user_themes/#{theme.id}/colors/#{color_scheme.id}.json"
        expect(response).to have_http_status(403)
      end
    end

    context 'logged in as user 1' do
      before do
        sign_in(user1)
      end

      it 'can delete theme' do
        delete "/user_themes/#{theme.id}.json"
        expect(response).to be_successful
        expect { theme.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'can update theme' do
        put "/user_themes/#{theme.id}.json", params: {
          theme: {
            name: "New Theme Title"
          }
        }
        expect(response).to be_successful
        theme.reload
        expect(theme.name).to eq("New Theme Title")
      end

      it 'can create color scheme for theme' do
        post "/user_themes/#{theme.id}/colors.json"
        expect(response).to be_successful
        theme.reload
        expect(theme.color_schemes.count).to eq(1)
      end

      it 'can edit color scheme' do
        put "/user_themes/#{theme.id}/colors/#{color_scheme.id}.json", params: {
          color_scheme: {
            name: "Some New Name",
            colors: []
          }
        }
        expect(response).to be_successful
        color_scheme.reload
        expect(color_scheme.name).to eq("Some New Name")
      end

      it "can delete color scheme" do
        delete "/user_themes/#{theme.id}/colors/#{color_scheme.id}.json"
        expect(response).to be_successful
        expect { color_scheme.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

end
