require 'rails_helper'

RSpec.feature "Games", type: :feature do

  before do
    @user = FactoryBot.create(:user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Log in"

    @game_search = "portal-2"

    visit game_path(@game_search)
  end

  scenario "user adds a game to their library" do
    expect {
      click_link "Add to library"
      game = @user.games.first

      expect(page).to have_content "Congrats! You added #{game.name} to your library!"
      expect(game.name).to eq "Portal 2"
    }.to change(@user.games, :count).by 1
  end

  scenario "two users add the same game to their libraries" do
    user_two = FactoryBot.create(:user)

    click_link "Add to library"
    click_link "Sign out"

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user_two.email
    fill_in "Password", with: user_two.password
    click_button "Log in"

    visit game_path(@game_search)

    expect {
      click_link "Add to library"
    }.to change(user_two.games, :count).by 1

    expect(Game.count).to eq 1
    expect(Game.first.users.count).to eq 2
  end

  scenario "user removes game from their library" do
    click_link "Add to library"

    game = @user.games.first
    
    expect {
      click_link "Remove from library"
      expect(page).to have_content "You have successfully removed #{game.name} from your library."
    }.to change(@user.games, :count).by -1

    expect(@user.games.count).to eq 0
    expect(Game.count).to eq 1 # Should not remove the game itself, just the game from user's library
  end
  
  scenario "user adds game from search results" do
    visit search_games_path
    fill_in "Enter game name", with: "dota 2"
    within "#game-search" do
      click_button "Search"
    end

    expect(Game.count).to eq 0

    expect {
      within "#dota-2" do
        click_button "Add to library"
      end
      expect(page).to have_button "Remove from library"
    }.to change(@user.games, :count).by 1

    expect(Game.count).to eq 1
    expect(Game.first.name).to eq "Dota 2"
  end


end
