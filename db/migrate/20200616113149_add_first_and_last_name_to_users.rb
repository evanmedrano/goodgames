class AddFirstAndLastNameToUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :name, :string

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
  end

  def down
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string

    add_column :users, :name, :string
  end
end
