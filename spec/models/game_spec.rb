require 'rails_helper'
require 'models/concerns/commentable_spec'

describe Game do
  context "associations" do
    context "has_many" do
      it { should have_many :user_games }
      it { should have_many :users }
      it_behaves_like :commentable
    end
  end

  context "validations" do
    context "presence" do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:slug) }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of(:name).case_insensitive }
      it { should validate_uniqueness_of(:slug).case_insensitive }
    end
  end

  describe ".find_in_db" do
    context "when the array of games includes a game in the database" do
      it "replaces the RawgApi::Game instance with a Game instance" do
        VCR.use_cassette("replaces RawgApi::Game with Game instance") do
          RawgApi::Game.new({ slug: "portal-2" }).save
          response = RawgApi::GameService.all("portal 2")

          games = described_class.find_in_db(response)
          games_in_db = games.select { |game| game.is_a?(described_class) }

          expect(games_in_db.count).to eq(1)
        end
      end
    end

    context "when the array of games doesn't include a game in the database" do
      it "returns only RawgApi::Game instances" do
        VCR.use_cassette("returns only RawgApi::Game instances") do
          response = RawgApi::GameService.all("portal 2")

          games = described_class.find_in_db(response)
          games_in_db = games.select { |game| game.is_a?(described_class) }

          expect(games_in_db.count).to eq(0)
        end
      end
    end

    context "when the array of games is empty" do
      it "does not run any ActiveRecord queries" do
        VCR.use_cassette("no ActiveRecord queries if games array is empty") do
          allow(described_class).to receive(:all).and_call_original

          RawgApi::GameService.all("BadQueryToReturnNoGames")

          expect(described_class).not_to have_received(:all)
        end
      end
    end
  end

  describe ".filter_by_genre" do
    it "returns all games that include queried genre" do
      create(:game, genres: [{ name: "Action" }])
      create(:game, genres: [{ name: "Action" }])

      expect(described_class.filter_by_genre("Action").count).to eq(2)
    end
  end

  describe ".filter_by_platform" do
    it "returns all games that include queried platform" do
      create(:game, platforms: [{ name: "PC" }])
      create(:game, platforms: [{ name: "PC" }])

      expect(described_class.filter_by_platform("PC").count).to eq(2)
    end
  end

  describe ".filter_by_status" do
    it "returns all games of selected status from user's games list" do
      user_game = create(:user_game, status: "Currently own")
      user, status = user_game.user, user_game.status
      create(:user_game, status: "Beat", user: user_game.user)

      expect(user.games.count).to eq(2)
      expect(described_class.filter_by_status(user, status).count).to eq(1)
    end
  end

  describe "#current_status" do
    it "returns the game's current status on a user's games list" do
      game = create(:game)
      user_game = create(:user_game, game: game, status: "Beat")

      expect(game.current_status(user_game.user)).to eq("Beat")
    end
  end

  describe "#current_platform" do
    it "returns the game's current platform on a user's games list" do
      game = create(:game)
      user_game = create(:user_game, game: game, platform: "PC")

      expect(game.current_platform(user_game.user)).to eq("PC")
    end
  end

  describe "#platforms_names" do
    it "returns an array of the game's platforms names" do
      game = create(:game, platforms: [{ id: 4, name: "PC", slug: "pc" }])

      expect(game.platform_names).to eq(["PC"])
    end
  end
end
