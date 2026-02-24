# frozen_string_literal: true

RSpec.describe "User themes" do
  before { enable_current_plugin }

  it "can open the code editor from a theme's show page" do
    user = Fabricate(:user)
    theme = Fabricate(:theme, user: user)
    theme.set_field(target: :common, name: :scss, value: "body { color: red; }")
    theme.save!

    sign_in(user)
    visit "/u/#{user.username}/themes/#{theme.id}"

    find(".btn-default.edit").click

    expect(page).to have_current_path(%r{/u/#{user.username}/themes/#{theme.id}/common/scss/edit})
    expect(page).to have_css(".current-style")
  end

  it "can navigate to the user themes page and create a theme" do
    user = Fabricate(:user)
    sign_in(user)

    visit "/u/#{user.username}"
    find("a[href='/u/#{user.username}/themes']").click
    find(".user-create-theme .btn-primary").click

    find(".install-theme-content__theme-name").fill_in with: "My theme"
    find(".d-modal__footer .btn-primary").click

    try_until_success { expect(Theme.last.user.id).to eq(user.id) }

    expect(page).to have_current_path("/u/#{user.username}/themes/#{Theme.last.id}")
    expect(page).to have_css(".theme-controls")
  end
end
