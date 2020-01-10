class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :description
      t.string :released
      t.string :background_image
      t.string :clip
      t.string :esrb_rating
      t.string :website
      t.string :slug
      t.string :platforms, array: true, default: []
      t.string :genres, array: true, default: []

      t.timestamps
    end
  end
end
