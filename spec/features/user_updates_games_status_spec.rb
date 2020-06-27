require 'rails_helper'

feature "user updates game's status" do
  include ActiveJob::TestHelper

  scenario "to a new status", js: true do
    VCR.use_cassette("user successfully updates game's status") do
      user, game = create_user_and_game
      create(:user_game, user: user, game: game, status: "Owned")

      visit game_path(game.slug, as: logged_in_user(user))
      select "Playing", from: "status"

      expect(game.current_status(user)).to eq("Playing")
      expect(page).to have_content("You successfully updated #{game.name}!")
    end
  end

  scenario "to a 'Beat' game status", js: true do
    VCR.use_cassette("user updates game status to 'Beat'") do
      user, game = create_user_and_game
      create(:user_game, user: user, game: game, status: "Playing")

      visit game_path(game.slug, as: logged_in_user(user))
      select "Beat", from: "status"

      expect(game.current_status(user)).to eq("Beat")
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq(1)
      expect(page).to have_content("You successfully updated #{game.name}!")
    end
  end

  def create_user_and_game
    return create(:user), create(:game, slug: "portal-2")
  end
end
