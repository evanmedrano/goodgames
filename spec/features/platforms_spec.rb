require 'rails_helper'

RSpec.feature "Platforms", type: :feature do
  scenario "guest visits index page" do
    visit platforms_path

    expect(page).to have_content "Nintendo DSi"
  
    within "#linux" do
      click_button "Show more"
    end
   
    expect(page).to have_content "Linux"
  end

  scenario "user visits the platform show page" do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)

    visit platform_path("playstation4")

    expect(page).to have_content "Tomb Raider (2013)"

    expect {
      within "#limbo" do
        click_button "Add to library"
      end
      expect(page).to have_button "Remove from library"
    }.to change(user.games, :count).by 1
  end
end
