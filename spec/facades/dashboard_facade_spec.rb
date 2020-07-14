require 'rails_helper'

describe DashboardFacade do
  describe "#games_playing" do
    it "returns all games the current user is playing (limit 3)" do
      user.user_games.update_all(status: "Playing")

      dashboard = described_class.new(user)

      expect(dashboard.games_playing).to eq(user.games)
    end
  end

  describe "#games_to_play" do
    it "returns all games the current user has on their wishlist (limit 3)" do
      user.user_games.update_all(status: "Wishlist")

      dashboard = described_class.new(user)

      expect(dashboard.games_to_play).to eq(user.games)
    end
  end

  describe "#game_shelves" do
    it "returns the game count for each user_game status" do
      2.times { user.user_games << create(:user_game, status: "Wishlist") }

      dashboard = described_class.new(user)

      expect(dashboard.game_shelves_count).to eq(game_shelves)
    end
  end

  describe "#game_recommendation" do
    context "when a user has a game in their library" do
      it "returns a rawg suggested game based on their games library" do
        VCR.use_cassette("user gets a game recommendation on dashboard") do
          dashboard = described_class.new(user)

          game = dashboard.game_recommendation

          expect(game.class).to be(RawgApi::Game)
        end
      end
    end

    context "when a user has no games in their library" do
      it "returns a random game from database" do
        user.games.destroy_all

        dashboard = described_class.new(user)

        game = dashboard.game_recommendation

        expect(game.class).to be(Game)
      end
    end
  end

  def user
    # game library trait creates 2 user_games w/ a status of "Currently own"
    @user ||= create(:user, :with_a_games_library)
  end

  def game_shelves
    {
      "Wishlist" => 2,
      "Beat" => 0,
      "Playing" => 0,
      "Currently own" => 2,
      "Owned" => 0
    }
  end
end
