require 'rails_helper'

feature "user logs out" do
  scenario "successfully" do
    visit root_path(as: logged_in_user)

    click_link "Sign out"

    expect(page).to have_content("Sign in")
  end
end
