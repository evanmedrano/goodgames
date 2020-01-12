class Game < ApplicationRecord
  require 'Rawgapi'

  validates :name, uniqueness: true

  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games, source: :user

  TOP_GENRES = ["Action", "Shooter", "RPG", "Strategy", "Puzzle", "Sports", "Racing", "Adventure"]

  # Checks to see if the database already has the game and then defers to RawgAPI to fill in the rest
  def self.find_in_db(games)
    games.map { |game| Game.find_by(name: game["name"]) == nil ? game : Game.find_by(name: game["name"]) }
  end

  def self.get_info(games)
    games = games.map { |game| RawgAPI.get_game(game["slug"], "genres") }
  end

end
