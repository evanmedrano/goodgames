class Game < ApplicationRecord
  require 'Rawgapi'

  validates :name, uniqueness: true

  has_many :comments, dependent: :destroy
  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games

  scope :filter_by_genre, -> (genre) { where('genres @>ARRAY[?]::varchar[]', genre) }

  # Checks to see if a game is in the db, if not then we use the JSON data from the api call
  def self.find_in_db(games)
    games_in_db = Game.all.pluck(:name)
    games.map do |game| 
      games_in_db.include?(game["name"]) ? Game.find_by(name: game["name"]) : game 
    end
  end

  def self.filter_by_status(user, status)
    joins(:user_games).where(user_games: { user_id: user.id, status: status })
  end

  def current_status(user)
    user_games.find_by(user: user).status
  end

  def platform_names
    platforms.map { |platform| platform.dig("platform", "name") }
  end

  def current_platform(user)
    user_games.find_by(user: user).platform
  end

  def was_added?(user, game)
    games = Game.joins(:user_games).where(user_games: {user: user }).pluck(:name)
    games.include?(game.name) 
  end
 
end
