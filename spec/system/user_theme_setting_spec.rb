# frozen_string_literal: true

RSpec.describe "Discourse Theme Creator - user theme setting", system: true do
  fab!(:current_user) { Fabricate(:user) }
  fab!(:theme) { Fabricate(:theme, component: true, user: current_user) }

  before do
    theme.set_field(target: :settings, name: "yaml", value: <<~YAML)
        super_feature_enabled:
          type: bool
          default: false
          refresh: false
      YAML

    ThemeSetting.create!(
      theme: theme,
      data_type: ThemeSetting.types[:bool],
      name: "super_feature_enabled",
    )
    theme.save!
  end

  let(:admin_customize_themes_page) { PageObjects::Pages::AdminCustomizeThemes.new }

  before { sign_in(current_user) }

  it "can edit settings" do
    visit "/u/#{current_user.username}/themes/#{theme.id}"

    find("[data-setting='super_feature_enabled'] .setting-value").click
    find(".setting-controls__ok").click

    expect(admin_customize_themes_page).to have_overridden_setting("super_feature_enabled")
  end
end
