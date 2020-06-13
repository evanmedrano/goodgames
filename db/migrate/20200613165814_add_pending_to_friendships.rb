class AddPendingToFriendships < ActiveRecord::Migration[6.0]
  def change
    add_column :friendships, :pending, :boolean, default: true
  end
end
