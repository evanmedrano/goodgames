require 'rails_helper'

feature "user sends a friend request" do
  scenario "as a guest user" do
    user = create(:user)
    visit user_library_path(user)

    click_button "Send friend request"

    expect(page).to have_content "Log in"
  end

  scenario "as a logged in user" do
    user = create(:user)
    requester = create(:user)
    visit user_library_path(user, as: logged_in_user(requester))

    click_button "Send friend request"

    expect(page).to have_content "Friend request sent."
  end
end
