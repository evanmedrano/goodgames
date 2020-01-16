class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :destroy
  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games
           
  validates :name, presence: true

  def self.same_game_status(game, status, user)
    joins(:user_games).where(user_games: { game: game, status: status }).reject { |u| u == user }
  end

  def added_game?(game)
    self.games.include?(game)
  end

end
