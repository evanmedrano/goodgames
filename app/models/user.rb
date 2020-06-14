class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :comments, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
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

  def has_pending_friendship_with?(library_owner_id)
    friendships.where(friend_id: library_owner_id, pending: true).any?
  end

  def is_friends_with?(library_owner_id)
    friendships.where(friend_id: library_owner_id, pending: false).any?
  end

  def sent_friend_request_to?(friend_id)
    friendships.where(
      user_id: self.id, friend_id: friend_id, request_sent_by: self.id
    ).any?
  end

  def first_name
    name.split[0]
  end
end
