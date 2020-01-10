require 'rails_helper'

RSpec.feature "Users", type: :feature do
  
  scenario "user successfully signs up" do
    @user = FactoryBot.build(:user)

    visit root_path
    click_link "Sign up"
    fill_in "Name", with: @user.name
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    fill_in "Password confirmation", with: @user.password

    expect {
      click_button "Sign up"
    }.to change(User, :count).by 1
    
  end
end
