# frozen_string_literal: true

describe "User themes", type: :system do
  before { enable_current_plugin }

  it "can navigate to the user themes page and create a theme" do
    user = Fabricate(:user)
    sign_in(user)

    visit "/u/#{user.username}"
    find("a[href='/u/#{user.username}/themes']").click
    find(".user-create-theme .btn-primary").click

    find(".install-theme-content__theme-name").fill_in with: "My theme"
    find(".d-modal__footer .btn-primary").click

    try_until_success do
      expect(Theme.last.user.id).to eq(user.id)
    end

    expect(page).to have_current_path("/u/#{user.username}/themes/#{Theme.last.id}")
    expect(page).to have_css(".theme-controls")
  end
end