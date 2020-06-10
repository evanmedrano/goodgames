require 'rails_helper'

feature "user views a games library" do
  scenario "as a guest user" do
    user = create(:user)
    add_games_to_library(user)

    visit user_library_path(user)

    expect(page).to have_selector('.card', count: 3)
    expect(page).not_to have_selector("input[value='Remove from library']")
  end

  def add_games_to_library(user)
    3.times { user.games << create(:game) }
  end
end
