require 'rails_helper'

feature "user signs up" do
  scenario "successfully and has a confirmation instructions email sent" do
    visit new_user_registration_path

    submit_form

    expect(User.count).to eq(1)
    expect(page).not_to have_content("Sign out")
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  scenario "with missing fields" do
    visit new_user_registration_path

    submit_form(email: "")

    expect(User.count).not_to eq(1)
    expect(page).to have_content("Email can't be blank")
  end

  scenario "with an existing email" do
    create(:user, email: "test@example.com")
    visit new_user_registration_path

    submit_form(email: "test@example.com")

    expect(User.count).not_to eq(2)
    expect(page).to have_content("Email has already been taken")
  end

  def submit_form(options = {})
    fill_in "First name", with: "Evan"
    fill_in "Last name", with: "Medrano"
    fill_in "Email", with: options[:email] || "evan@example.com"
    fill_in "Password", with: "foobar"
    fill_in "Password confirmation", with: "foobar"
    click_button "Sign up"
  end
end
