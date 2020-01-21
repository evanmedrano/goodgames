require 'rails_helper'

RSpec.feature "Platforms", type: :feature do
  scenario "guest visits index page" do
    visit platforms_path

    expect(page).to have_content "Nintendo DSi"
    expect(page).to have_selector('.card', count: 49) # 49 is the total amount of platforms the RawgAPI currently has
  end

  scenario "user visits the platform show page" do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)

    visit platform_path("playstation4")

    expect(page).to have_content "Tomb Raider (2013)"
    click_link "Tomb Raider (2013)"

    expect {
      within ".game__form" do
        click_link "Add to library"
      end
      expect(page).to have_link "Remove from library"
    }.to change(user.games, :count).by 1

    visit platform_path("playstation4")
    expect(page).to have_content "You currently have 1 PlayStation 4 game in your gaming library"
  end 
end
