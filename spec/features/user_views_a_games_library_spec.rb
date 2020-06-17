require 'rails_helper'

feature "user views a games library" do
  scenario "as a guest user" do
    user = create(:user)
    add_games_to_library(user)

    visit user_library_path(user)

    expect(page).to have_game_cards
    expect(page).not_to have_remove_from_library_text
  end

  scenario "as the games library owner" do
    user = create(:user)
    add_games_to_library(user)

    visit user_library_path(user, as: logged_in_user(user))

    expect(page).to have_game_cards
    expect(page).to have_remove_from_library_text
  end

  scenario "as a logged in user that doesn't own the games library" do
    user = create(:user)
    add_games_to_library(user)

    visit user_library_path(user, as: logged_in_user)

    expect(page).to have_game_cards
    expect(page).not_to have_remove_from_library_text
  end

  scenario "and filters the games list by status" do
    user = create(:user)
    add_games_to_library(user)

    visit user_library_path(user)

    expect(page).to have_game_cards

    click_link "Wishlist"

    expect(page).to have_game_cards(count: 1)
  end

  scenario "with an invalid user_id in params" do
    visit user_library_path(1)

    expect(page).to have_content("Game over!")
  end


  def add_games_to_library(user)
    2.times { create(:user_game, user: user, status: "Beat") }
    create(:user_game, user: user, status: "Wishlist")
  end

  def have_game_cards(count: 3)
    have_selector('.card', count: count)
  end

  def have_remove_from_library_text(count: 3)
    have_selector("input[value='Remove from library']", count: count)
  end
end
