# frozen_string_literal: true

RSpec.describe "Discourse Theme Creator - user theme object setting", system: true do
  fab!(:admin)
  fab!(:theme) { Fabricate(:theme, name: "Cool theme 1", component: true, user: admin) }

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

  let(:admin_objects_setting_editor_page) { PageObjects::Pages::AdminObjectsSettingEditor.new }

  before do
    objects_setting
    sign_in(admin)
  end

  it "can edit object settings" do
    visit "/u/#{admin.username}/themes/#{theme.id}"

    # Wait for the theme settings section to appear
    expect(page).to have_text("Custom theme settings")

    # The setting should be visible with the edit button
    expect(page).to have_css("[data-setting='objects_setting']")
    find("[data-setting='objects_setting'] .setting-value-edit-button").click

    admin_objects_setting_editor_page.fill_in_field("name", "test").save

    expect(page).to have_current_path("/u/#{admin.username}/themes/#{theme.id}")

    find("[data-setting='objects_setting'] .setting-value-edit-button").click
    expect(admin_objects_setting_editor_page).to have_setting_field("name", "test")
  end
end
