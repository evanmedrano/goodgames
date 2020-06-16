require 'rails_helper'

describe LibraryFacade do
  describe "#id" do
    it "returns the user's id" do
      user = create(:user)
      library_facade = described_class.new(user)

      expect(library_facade.id).to eq(user.id)
    end
  end

  describe "#owner" do
    it "returns the user's first name" do
      user = create(:user, first_name: "Evan")
      library_facade = described_class.new(user)

      expect(library_facade.owner).to eq("Evan")
    end
  end

  describe "#games" do
    context "when there is no game status param" do
      it "returns all of the user's games" do
        user = create(:user, first_name: "Evan")
        library_facade = described_class.new(user)

        add_games_to_library(user)

        expect(library_facade.games.count).to eq(3)
      end
    end

    context "when there is a game status param" do
      it "returns all of the games that have the given status" do
        user = create(:user, first_name: "Evan")
        library_facade = described_class.new(user, "Owned")

        add_games_to_library(user)
        library_facade.update_games_display

        expect(library_facade.games.count).to eq(1)
      end
    end
  end

  describe "#update_games_display" do
    it "updates the user's games array based on status" do
      user = create(:user, first_name: "Evan")
      library_facade = described_class.new(user, "Owned")

      add_games_to_library(user)
      library_facade.update_games_display

      expect(library_facade.games.count).to eq(1)
    end
  end

  def add_games_to_library(user)
    2.times { user.games << create(:game) }
    create(:user_game, user: user, status: "Owned")
  end
end
