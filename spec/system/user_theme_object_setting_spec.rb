# frozen_string_literal: true

RSpec.describe "Discourse Theme Creator - user theme object setting", system: true do
  fab!(:current_user) { Fabricate(:admin) }
  fab!(:theme) { Fabricate(:theme, name: "Cool theme 1", component: true, user: current_user) }

  let(:objects_setting) do
    theme.set_field(
      target: :settings,
      name: "yaml",
      value: File.read("#{Rails.root}/spec/fixtures/theme_settings/objects_settings.yaml"),
    )

    theme.save!
    theme.settings[:objects_setting]
  end

  let(:admin_customize_themes_page) { PageObjects::Pages::AdminCustomizeThemes.new }

  let(:admin_objects_theme_setting_editor_page) do
    PageObjects::Pages::AdminObjectsThemeSettingEditor.new
  end

  before do
    objects_setting
    sign_in(current_user)
  end

  it "can edit object settings" do
    visit "/u/#{current_user.username}/themes/#{theme.id}"

    admin_customize_themes_page.click_edit_objects_theme_setting_button("objects_setting")
    admin_objects_theme_setting_editor_page.fill_in_field("name", "test")
    admin_objects_theme_setting_editor_page.save

    expect(admin_objects_theme_setting_editor_page).to have_setting_field("name", "test")
  end
end
