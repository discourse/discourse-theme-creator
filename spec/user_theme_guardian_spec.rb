require 'rails_helper'

RSpec.describe ::Guardian do
  let(:user1) { Fabricate(:user) }
  let(:user2) { Fabricate(:user) }
  let(:admin) { Fabricate(:admin) }
  let(:guardian1) { Guardian.new(user1) }
  let(:guardian2) { Guardian.new(user2) }
  let(:adminGuardian) { Guardian.new(admin) }
  let(:theme) { Theme.create!(name: "My New Theme", user_id: user1.id) }

  describe 'hotlinking protection' do
    it 'allows own themes' do
      expect(guardian1.allow_themes?(theme.id)).to eq(true)
    end

    it 'disallows other themes' do
      expect(guardian2.allow_themes?(theme.id)).to eq(false)
    end

    it 'disallows other themes for admins' do
      # This is to reduce XSS risk
      expect(adminGuardian.allow_themes?(theme.id)).to eq(false)
    end
  end

  describe 'editing protection' do
    it 'allows editing own themes' do
      expect(guardian1.can_edit_user_theme?(theme)).to eq(true)
    end

    it 'disallows editing other themes' do
      expect(guardian2.can_edit_user_theme?(theme)).to eq(false)
    end

    it 'allows staff to edit other themes' do
      expect(adminGuardian.can_edit_user_theme?(theme)).to eq(true)
    end
  end

  describe 'share theme protection' do
    it 'allows all users to share when site setting blank' do
      SiteSetting.theme_creator_share_groups = ''
      expect(guardian1.can_share_user_theme?(theme)).to eq(true)
    end

    it 'restricts by group properly' do
      group = Fabricate(:group, name: "team")
      user = Fabricate(:user, username: 'david')
      group.add(user)

      SiteSetting.theme_creator_share_groups = 'team'
      user_guardian = Guardian.new(user)
      expect(user_guardian.can_share_user_theme?(theme)).to eq(true)
      expect(guardian1.can_share_user_theme?(theme)).to eq(false)
    end
  end

  describe 'viewing theme' do
    it 'allows viewing own themes' do
      expect(guardian1.can_see_user_theme?(theme)).to eq(true)
    end

    it 'disallows viewing other unshared themes' do
      expect(guardian2.can_see_user_theme?(theme)).to eq(false)
    end

    it 'allows viewing other themes when shared' do
      theme.share_slug = "mytheme"
      theme.save!
      SiteSetting.theme_creator_share_groups = ''

      expect(guardian2.can_see_user_theme?(theme)).to eq(true)
    end

    it 'disallows viewing other shared themes from disallowed owners' do
      theme.share_slug = "mytheme"
      theme.save!
      SiteSetting.theme_creator_share_groups = 'team'

      expect(guardian2.can_see_user_theme?(theme)).to eq(false)
    end
  end

end
