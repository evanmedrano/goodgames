class ChangeColumnDefaultOfGenresInGames < ActiveRecord::Migration[6.0]
  def change
    change_column_default :games, :genres, nil
  end
end
