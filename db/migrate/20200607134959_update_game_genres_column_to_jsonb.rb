class UpdateGameGenresColumnToJsonb < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :genres, :string, array: false
  end
end
