class AddUniqueIndexOnNameToGames < ActiveRecord::Migration[6.0]
  def change
    add_index :games, :name, unique: true
  end
end
