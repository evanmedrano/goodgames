class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user, uniqueness: { scope: :game, message: "already added this game to your library!" }

  validates :status, presence: true, 
                   inclusion: { in: %w{ Currently\ own Owned Beat Playing Wishlist },
                     message: "%{value} is not a valid status" }
  
  default_scope { order(created_at: :desc) }

  def self.find_game(user, game)
    joins(:user, :game).where(user: user, game: game).ids
  end
  
end
