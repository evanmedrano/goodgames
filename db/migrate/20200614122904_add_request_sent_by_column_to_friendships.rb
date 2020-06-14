class AddRequestSentByColumnToFriendships < ActiveRecord::Migration[6.0]
  def change
    add_column :friendships, :request_sent_by, :integer
  end
end
