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

end
