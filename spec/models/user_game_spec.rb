require 'rails_helper'

RSpec.describe UserGame, type: :model do

  before do
    @user_game = FactoryBot.create(:user_game)
  end
  
  describe "Validations" do

    it "is valid with a game, user, and status" do
      expect(@user_game).to be_valid
    end
    
    it "is invalid with the same game/user pair" do
      user_game_2 = FactoryBot.build_stubbed(:user_game, user: @user_game.user, game: @user_game.game)

      user_game_2.valid?
      expect(user_game_2.errors.messages[:user]).to include "already added this game to your library!"
    end

    it "is invalid with a custom name" do
      bad_status = FactoryBot.build_stubbed(:user_game, status: "Custom status")

      bad_status.valid?
      expect(bad_status.errors.messages[:status]).to include "#{bad_status.status} is not a valid status"
    end

    it "is invalid without a name" do
      bad_status = FactoryBot.build_stubbed(:user_game, status: nil)

      bad_status.valid?
      expect(bad_status.errors.messages[:status]).to include "can't be blank"
    end
  end

  describe "Attributes" do
    it "automatically sets the game status as 'Currently own'" do
      expect(@user_game.status).to eq "Currently own"
    end

    it "automatically sets the user_game platform equal to the added game's first platform" do
      expect(@user_game.platform).to eq @user_game.game.platforms.first
    end
  end
  
end
