require "rails_helper"

describe RawgApi::GameService do
  describe ".all" do
    context "without a query" do
      it "returns a preset list of 20 games" do
        VCR.use_cassette("returns a preset list of 20 games") do
            response = described_class.all

            expect(response.count).to eq(20)
         end
      end
    end

    context "with a successful query" do
      it "returns the searched for game and/or similar games within response" do
        VCR.use_cassette("returns the searched for game within response") do
          response = described_class.all("super smash brothers")
          game_names = response.map(&:name)

          expect(game_names.any?(/super smash bros/i)).to eq(true)
        end
      end
    end

    context "with an unsuccessful query" do
      it "returns no games" do
        VCR.use_cassette("returns no games") do
          response = described_class.all("RandomQueryForNoGames")

          expect(response.count).to eq(0)
        end
      end
    end
  end

  describe ".find" do
    context "with a game that is in the database" do
      it "returns the game data" do
        VCR.use_cassette("returns the game data") do
          game = create(:game, slug: "portal-2", name: "Portal 2")
          response = described_class.find(game.slug)

          expect(response.name).to eq(game.name)
        end
      end
    end

    context "with a game that is not in the database" do
      it "returns no game data" do
        VCR.use_cassette("returns no game data") do
          response = described_class.find("random-game-data-here")

          expect(response.name).to eq(nil)
        end
      end
    end
  end

  describe ".set_related_game_content" do
    it "returns data related to the game" do
      VCR.use_cassette("returns data related to the game") do
        game = create(:game, slug: "portal-2")
        described_class.set_related_game_content(game)

        expect(game.suggested_games.any?).to eq(true)
        expect(game.series_games.any?).to eq(true)
        expect(game.screenshots.any?).to eq(true)
        expect(game.users_playing.any?).to eq(false)
        expect(game.users_finished.any?).to eq(false)
      end
    end
  end

  describe ".get_suggested_games" do
    it "returns suggested games" do
      VCR.use_cassette("returns suggested games") do
        game = create(:game, slug: "portal-2")
        described_class.set_suggested_games(game)

        expect(game.suggested_games.any?).to eq(true)
      end
    end
  end
end
