class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user, uniqueness: { scope: :game_id }

  validates :status, presence: true, 
                   inclusion: { in: %w{ Currently\ own Owned Beat Playing Wishlist } }
  
  default_scope { order(created_at: :desc) }

  delegate :name, to: :game, prefix: true

  before_create :add_platform

  def self.find_game(user, game)
    joins(:user, :game).where(user: user, game: game).ids
  end

  private

    def add_platform
      write_attribute(:platform, game.platforms.first) 
    end
  
end
