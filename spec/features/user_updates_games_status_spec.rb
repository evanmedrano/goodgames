require 'rails_helper'

feature "user updates game's status" do
  scenario "to a new status", js: true do
    VCR.use_cassette("user successfully updates game's status") do
      user, game = create_user_and_game
      create(:user_game, user: user, game: game, status: "Beat")

      visit game_path(game.slug, as: logged_in_user(user))
      select "Playing", from: "status"

      expect(game.current_status(user)).to eq("Playing")
      expect(page).to have_content("You successfully updated #{game.name}!")
    end
  end

  def create_user_and_game
    return create(:user), create(:game, slug: "portal-2")
  end
end
