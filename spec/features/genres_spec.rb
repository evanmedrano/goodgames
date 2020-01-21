require 'rails_helper'

RSpec.feature "Genres", type: :feature do
  
  scenario "guest visits index page" do
    visit genres_path

    expect(page).to have_content "Massively Multiplayer"
    expect(page).to have_selector('.card', count: 19) # 19 is the total amount of genres the RawgAPI currently has
  end

  scenario "user visits the genre show page" do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)

    visit genre_path("racing")

    expect(page).to have_content "Need For Speed: Hot Pursuit"
    click_link "DiRT Rally"
   
    expect {
      within ".game__form" do
        click_link "Add to library"
      end
      expect(page).to have_link "Remove from library"
    }.to change(user.games, :count).by 1

    visit genre_path("racing")
    expect(page).to have_content "You currently have 1 Racing game in your gaming library"
  end

end
