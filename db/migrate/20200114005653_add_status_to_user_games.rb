class AddStatusToUserGames < ActiveRecord::Migration[6.0]
  def change
    add_column :user_games, :status, :string, default: "Currently own"
  end
end
