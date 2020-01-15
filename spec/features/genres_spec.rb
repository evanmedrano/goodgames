require 'rails_helper'

RSpec.feature "Genres", type: :feature do
  
  scenario "guest visits index page" do
    visit genres_path

    expect(page).to have_content "Massively Multiplayer"
    
  
    within "#board-games" do
      click_button "Show more"
    end
   
    expect(page).to have_content "Board Games"
  end

  scenario "user visits the genre show page" do
    user = FactoryBot.create(:user)
    login_as(user, scope: :user)

    visit genre_path("racing")

    expect(page).to have_content "Need For Speed: Hot Pursuit"

    expect {
      within "#driveclub" do
        click_button "Add to library"
      end
      expect(page).to have_button "Remove from library"
    }.to change(user.games, :count).by 1
  end

end
