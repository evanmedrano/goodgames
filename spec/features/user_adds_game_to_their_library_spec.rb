require 'rails_helper'

feature "user adds game to their library" do
  scenario "as a guest user" do
    VCR.use_cassette("guest user adds game to their library") do
      visit games_path

      click_on_first_add_to_library_button

      expect(page).to have_content("Log in")
    end
  end

  scenario "successfully" do
    VCR.use_cassette("user adds game to their library successfully") do
      visit games_path(as: logged_in_user)

      click_on_first_add_to_library_button

      expect_remove_from_library_button_text
    end
  end

  scenario "successfully from the games index page" do
    VCR.use_cassette("user adds game to their library from index page") do
      visit games_path(as: logged_in_user)

      click_on_first_add_to_library_button

      expect_remove_from_library_button_text
      expect(current_path).to eq("/games")
    end
  end

  scenario "successfully from the games show page" do
    VCR.use_cassette("user adds game to their library from show page") do
      game = create(:game, slug: "portal-2")
      visit game_path(game.slug, as: logged_in_user)

      click_on_first_add_to_library_button

      expect_remove_from_library_button_text
      expect(current_path).to eq("/games/#{game.slug}")
    end
  end

  scenario "successfully from the discover index page" do
    VCR.use_cassette("user adds game to their library from discover page") do
      game = create(:game, slug: "portal-2")
      visit game_discover_index_path(game.slug, as: logged_in_user)

      click_on_first_add_to_library_button

      expect_remove_from_library_button_text
      expect(current_path).to eq("/games/#{game.slug}/discover")
    end
  end

  scenario "after other users have added the same game to their libraries" do
    VCR.use_cassette("user adds game to their library after another user") do
      game = create(:game, slug: "portal-2")
      add_game_to_users_library(game)
      visit game_path(game.slug, as: logged_in_user)

      click_on_first_add_to_library_button

      expect(Game.count).to eq(1)
      expect(game.users.count).to eq(2)
    end
  end

  def click_on_first_add_to_library_button
    page.find('input[value="Add to library"]', match: :first).click
  end

  def expect_remove_from_library_button_text
    expect(page).to have_css('input[value="Remove from library"]')
  end

  def add_game_to_users_library(game)
    create(:user).games << game
  end
end
