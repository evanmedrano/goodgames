class UpdateGameGenresColumnToJsonbColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :games, :genres
    add_column :games, :genres, :jsonb, default: {}
  end
end
