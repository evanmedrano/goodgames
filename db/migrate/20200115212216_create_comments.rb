class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
