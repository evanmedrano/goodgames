require 'rails_helper'

RSpec.feature "Games", type: :feature do

  before do
    @user = FactoryBot.create(:user)
    @game = FactoryBot.create(:game, name: "Portal 2")
    login_as(@user, scope: :user)
  end

  scenario "user adds a game to their library" do
    visit game_path(@game.slug)

    click_link "Add to library"

    expect(page).to have_content "Congrats! You added a new game to your library!"
    expect(@user.games.first.name).to eq "Portal 2"
    expect(@user.games.count).to eq 1
    
    user_game = @user.user_games.first
    expect(user_game.platform).to eq @game.platforms.first
  end

  scenario "two users add the same game to their libraries" do
    @user.games << @game

    user_two = FactoryBot.create(:user)
    login_as(user_two, scope: :user)

    visit game_path(@game)

    expect {
      click_link "Add to library"
    }.to change(user_two.games, :count).by 1

    expect(Game.count).to eq 1
    expect(@game.users.count).to eq 2
  end

  scenario "user removes game from their library" do
    @user.games << @game
    visit game_path(@game)

    expect {
      click_link "Remove from library"
      expect(page).to have_content "You have successfully removed #{@game.name} from your library."
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

    expect {
      within "#dota-2" do
        click_button "Add to library"
      end
      expect(page).to have_button "Remove from library"
    }.to change(@user.games, :count).by 1

    expect(Game.count).to eq 2
    expect(Game.last.name).to eq "Dota 2"
  end

  scenario "user changes their game status", js: true do
    @user.games << @game
    user_game = @user.user_games.first

    visit games_user_path(@user)

    within "##{@game.slug}" do
      select "Beat", from: "status"
    end
    expect(page).to have_content "You successfully updated #{user_game.game_name}!"
    expect(user_game.reload.status).to eq "Beat"
  end

  scenario "user changes their game platform", js: true do
    @user.games << @game
    user_game = @user.user_games.first

    visit games_user_path(@user)

    within "##{@game.slug}" do
      select "Platform 2", from: "platform"
    end
    expect(page).to have_content "You successfully updated #{user_game.game_name}!"
    expect(user_game.reload.platform).to eq "Platform 2"
  end

  scenario "user goes to game show page to find others who are playing the game" do
    @user.games << @game
    user_game = @user.user_games.first
    user_game.update_attribute(:status, "Playing")

    visit game_path(@game)

    # It should not show any content if the current user is the ONLY person playing the game
    expect(page).to_not have_content "Users who are playing #{@game.name}"
    expect(page).to_not have_content "#{@user.name}"

    other_user = FactoryBot.create(:user)
    login_as(other_user, scope: :user)

    visit game_path(@game)

    expect(page).to have_content "Users who are playing #{@game.name}"
    expect(page).to have_content "#{@user.name}"
  end

  scenario "user goes to game show page to find others who beat the game" do
    @user.games << @game
    user_game = @user.user_games.first

    user_game.update_attribute(:status, "Beat")
    
    visit game_path(@game)

    # It should not show any content if the current user is the ONLY person beat the game
    expect(page).to_not have_content "Users who have beat #{@game.name}"
    expect(page).to_not have_content "#{@user.name}"

    other_user = FactoryBot.create(:user)
    login_as(other_user, scope: :user)

    visit game_path(@game)

    expect(page).to have_content "Users who have beat #{@game.name}"
    expect(page).to have_content "#{@user.name}"
  end

end
