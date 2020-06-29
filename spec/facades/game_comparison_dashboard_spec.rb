require 'rails_helper'

describe GameComparisonDashboard do
  describe "#games_not_in_common_for" do
    it "returns the count of games not in common for a particular user" do
      user, game = create(:user), create(:game)
      user_two = create(:user, :with_a_games_library, library_size: 4)
      user.games << game
      user_two.games << game
      g_c_d = described_class.new(user, user_two)

      expect(g_c_d.total_games_not_in_common_for(user)).to eq(0)
      expect(g_c_d.total_games_not_in_common_for(user_two)).to eq(4)
    end
  end

  describe "#percentage_in_common_for" do
    it "returns the percentage of games in common for a particular user" do
      user, game = create(:user), create(:game)
      user_two = create(:user, :with_a_games_library, library_size: 2)
      user.games << game
      user_two.games << game
      g_c_d = described_class.new(user, user_two)

      expect(g_c_d.percentage_in_common_for(user)).to eq("100%")
      expect(g_c_d.percentage_in_common_for(user_two)).to eq("33%")
    end
  end

  describe "#games_in_common" do
    it "returns all games in common between two users" do
      user, game = create(:user), create(:game)
      user_two = create(:user, :with_a_games_library)
      user.games << game
      user_two.games << game
      g_c_d = described_class.new(user, user_two)

      expect(g_c_d.games_in_common.count).to eq(1)
    end
  end
end
