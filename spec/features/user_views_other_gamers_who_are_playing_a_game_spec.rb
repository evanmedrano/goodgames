require 'rails_helper'

feature "user views other gamers who are playing a game" do
  scenario "when no gamers are playing" do
    VCR.use_cassette("user views no gamers are playing") do
      game = create(:game)

      visit game_path(game.slug)

      expect(page).to have_content("no other gamers who beat\n#{game.name}")
    end
  end

  scenario "when the current user is the only gamer who is playing" do
    VCR.use_cassette("current user views no others gamers who are playing") do
      user, game = create(:user), create(:game)
      create(:user_game, user: user, game: game, status: "Playing")

      visit game_path(game.slug, as: logged_in_user(user))

      expect(page).to have_content("no other gamers who beat\n#{game.name}")
    end
  end

  scenario "when there are other users who are playing" do
    VCR.use_cassette("user views others gamers who are playing") do
      user, game = create(:user), create(:game)
      create(:user_game, user: user, game: game, status: "Playing")

      visit game_path(game.slug)

      expect(page).to have_content(gamers_playing_text(game, user))
    end
  end

  def gamers_playing_text(game, user)
    "Gamers playing #{game.name}\n#{user.first_name}"
  end
end
