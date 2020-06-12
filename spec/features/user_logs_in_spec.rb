require 'rails_helper'

feature "user logs in" do
  scenario "successfully" do
    user = create(:user)
    visit new_user_session_path

    submit_form(user)

    expect(page).to have_content("Sign out")
  end

  scenario "with invalid fields" do
    user = create(:user, email: "test@example.com")
    visit new_user_session_path

    submit_form(user, email: "wrong@example.com")

    expect(page).to have_content("Invalid Email or password.")
  end

  def submit_form(user, options = {})
    fill_in "Email", with: options[:email] || user.email
    fill_in "Password", with: options[:password] || user.password
    click_button "Log in"
  end
end
