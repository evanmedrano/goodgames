class RemovePlatformsInGames < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :platforms, :string, default: [], array: true
  end
end
