require 'rails_helper'

RSpec.describe Game, type: :model do
  describe "Validations" do
    it "does not allow duplicate names" do
      game_one = FactoryBot.create(:game)
      game_two = FactoryBot.build_stubbed(:game, name: game_one.name)

      game_two.valid?
      expect(game_two.errors.messages[:name]).to include "has already been taken"
    end
  end
  
  describe "Associations" do
    it "can have many comments" do
      game      = FactoryBot.create(:game)
      comment   = FactoryBot.create(:comment, game: game)
      comment_2 = FactoryBot.create(:comment, game: game)

      expect(game.comments.count).to eq 2
    end
  end
end
