class Game < ApplicationRecord
  attr_accessor :suggested_games,
                :series_games,
                :screenshots,
                :users_playing,
                :users_finished

  include Commentable
  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  default_scope { order(created_at: :desc) }

  scope :filter_by_genre,    -> (genre)    { where('genres @> ARRAY[?]::varchar[]', genre) }
  scope :filter_by_platform, -> (platform) { where('platforms @> ?', [{ platform: { name: platform } }].to_json) }

  # Checks to see if a game is in the db, if not then we use the JSON data from
  # the api call
  def self.find_in_db(games)
    game_ids = Game.all.pluck(:id)

    games.map do |game|
      game_ids.include?(game.id) ? Game.find_by(id: game.id) : game
    end
  end

  def self.filter_by_status(user, status)
    joins(:user_games).where(user_games: { user_id: user.id, status: status })
  end

  def current_status(user)
    user_games.find_by(user: user).status
  end

  def platform_names
    platforms.map { |platform| platform["name"] }
  end

  def current_platform(user)
    user_games.find_by(user: user).platform
  end
end
