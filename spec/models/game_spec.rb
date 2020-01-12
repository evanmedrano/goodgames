require 'rails_helper'

RSpec.describe Game, type: :model do
  it "does not allow duplicate names" do
    game_one = FactoryBot.create(:game)
    game_two = FactoryBot.build(:game, name: game_one.name)

    game_two.valid?
    expect(game_two.errors.messages[:name]).to include "has already been taken"
  end
end
