require 'rails_helper'

feature "user views other gamers who beat a game" do
  scenario "when no gamers beat the game" do
    VCR.use_cassette("user views no gamers who beat the game") do
      game = create(:game)

      visit game_path(game.slug)

      expect(page).to have_content("no other gamers who beat\n#{game.name}")
    end
  end

  scenario "when the current user is the only gamer who beat the game" do
    VCR.use_cassette("current user views no others gamers who beat the game") do
      user, game = create(:user), create(:game)
      create(:user_game, user: user, game: game, status: "Beat")

      visit game_path(game.slug, as: logged_in_user(user))

      expect(page).to have_content("no other gamers who beat\n#{game.name}")
    end
  end

  scenario "when there are other users who beat the game" do
    VCR.use_cassette("user views others gamers who beat the game") do
      user, game = create(:user), create(:game)
      create(:user_game, user: user, game: game, status: "Beat")

      visit game_path(game.slug)

      expect(page).to have_content(gamers_who_beat_game_text(game, user))
    end
  end

  def gamers_who_beat_game_text(game, user)
    "Gamers who beat #{game.name}\n#{user.first_name}"
  end
end
