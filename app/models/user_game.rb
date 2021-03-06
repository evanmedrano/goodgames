class UserGame < ApplicationRecord
  belongs_to :game, touch: true
  belongs_to :user, touch: true

  validates :status,
            presence: true,
            inclusion: { in: %w[Currently\ own Owned Beat Playing Wishlist] }
  validates :user, uniqueness: { scope: :game_id }

  default_scope { order(created_at: :desc) }

  delegate :name, to: :game, prefix: true

  before_create :add_platform # Sets the first platform from game platforms array

  def self.find_game(user, game)
    joins(:user, :game).where(user: user, game: game).ids
  end

  private

  def add_platform
    platform = game.platforms.first["name"]
    write_attribute(:platform, platform)
  end
end
