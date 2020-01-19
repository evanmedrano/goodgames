require 'rails_helper'

RSpec.describe UserGame, type: :model do

  
  describe "Validations" do

    it "is valid with a game, user, and status" do
      user_game = FactoryBot.build_stubbed(:user_game)
      expect(user_game).to be_valid
    end

    it { is_expected.to validate_presence_of :status }

    subject { FactoryBot.create(:user_game) }

    it { is_expected.to validate_uniqueness_of(:user).scoped_to(:game_id) }

    it do
      should validate_inclusion_of(:status).
        in_array(%w{ Currently\ own Owned Beat Playing Wishlist }).on(:create)
    end

  end

  describe "Attributes" do
    subject(:user_game) { FactoryBot.create(:user_game)  }

    it "automatically sets the game status as 'Currently own'" do
      expect(user_game.status).to eq "Currently own"
    end

    it "automatically sets the user_game platform equal to the added game's first platform" do
      expect(user_game.platform).to eq user_game.game.platforms.first
    end
  end
  
end
