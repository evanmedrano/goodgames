class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user, uniqueness: { scope: :game, message: "already added this game to your library!" }

  validates :status, presence: true, 
                   inclusion: { in: %w{ Currently\ own Owned Beat Playing Wishlist },
                     message: "%{value} is not a valid status" }

end
