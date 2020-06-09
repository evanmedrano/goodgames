class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games

  validates :name, presence: true

  def self.same_game_status(current_user:, game:, status:)
    joins(:user_games).where(user_games: { game: game, status: status }).
      reject { |user| user == current_user }
  end

  def self.filter_user_game_genre(genre)
    joins(:games).merge(Game.filter_by_genre(genre))
  end

  def self.filter_user_game_platform(platform)
    joins(:games).merge(Game.filter_by_platform(platform))
  end

  def added_game?(game)
    self.games.include?(game)
  end

  def genre_game_count(genre)
    self.class.filter_user_game_genre(genre).where(id: self.id).count
  end

  def platform_game_count(platform)
    self.class.filter_user_game_platform(platform).where(id: self.id).count
  end

  def first_name
    name.split[0]
  end
end
