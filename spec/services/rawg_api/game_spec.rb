require "rails_helper"

describe RawgApi::Game do
  describe "#save" do
    context "with a game that is not in the database" do
      it "saves a new game to database" do
        VCR.use_cassette("saves a new game to database") do
          game = described_class.new({ slug: "portal-2" })

          game.save

          expect(Game.first.name).to eq("Portal 2")
        end
      end
    end

    context "with a game that is in the database" do
      it "does not create a new game" do
        VCR.use_cassette("does not create a new game") do
          create(:game, slug: "portal-2", name: "Portal 2")
          game = described_class.new({ slug: "portal-2" })

          game.save

          expect(Game.count).to eq(1)
        end
      end
    end

    context "with an invalid game" do
      it "does not create a new game" do
        VCR.use_cassette("does not create a new game with invalid data") do
          game = described_class.new

          game.save

          expect(Game.count).to eq(0)
        end
      end
    end
  end
end
