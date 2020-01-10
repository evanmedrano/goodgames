require 'rails_helper'

RSpec.describe UserGame, type: :model do
  
    describe "Validations" do
        it "is invalid with the same game/user pair" do
            user = FactoryBot.create(:user)
            game = FactoryBot.create(:game)

            user_game_1 = FactoryBot.create(:user_game, user: user, game: game)
            user_game_2 = FactoryBot.build(:user_game, user: user, game: game)

            user_game_2.valid?
            expect(user_game_2.errors.messages[:user]).to include "already added this game to your library!"
        end
    end
end
