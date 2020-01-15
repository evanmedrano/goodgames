class AddPlatformsToUserGames < ActiveRecord::Migration[6.0]
  def change
    add_column :user_games, :platform, :string
  end
end
