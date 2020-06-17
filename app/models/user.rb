class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :comments, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games
  has_many :received_messages, dependent: :destroy, foreign_key: :recipient_id,
    class_name: "Message"
  has_many :sent_messages, dependent: :destroy, foreign_key: :sender_id,
    class_name: "Message"

  validates :first_name, presence: true
  validates :last_name, presence: true

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

  def self.all_friends_of(user)
    params = { friend_id: user.id, pending: false }

    includes(:friendships).where(friendships: params)
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

  def is_friends_with?(user_id)
    friendships.where(friend_id: user_id, pending: false).any?
  end

  def sent_friend_request_to?(friend_id)
    friendships.where(
      user_id: self.id, friend_id: friend_id, request_sent_by: self.id
    ).any?
  end

  def is_currently_playing_a_game?
    user_games.where(status: "Playing").any?
  end

  def currently_playing
    games.where(user_games: { status: 'Playing' }).first
  end

  def can_add_as_a_friend?(friend)
    self != friend && !self.is_friends_with?(friend.id)
  end

  def name
    "#{first_name} #{last_name}"
  end
end
