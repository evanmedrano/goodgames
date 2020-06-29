require 'rails_helper'

describe GameComparisonDashboard do
  describe "#games_in_common" do
    it "returns all games in common between two users" do
      user, game = create(:user), create(:game)
      user_two = create(:user, :with_a_games_library)
      user.games << game
      user_two.games << game
      game_comparison_dashboard = described_class.new(user, user_two)

      expect(game_comparison_dashboard.games_in_common.count).to eq(1)
    end
  end
end
