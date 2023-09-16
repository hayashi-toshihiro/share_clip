class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string :name, null: false
      t.string :image_url, null: false
      t.string :image_id

      t.timestamps
    end
    add_index :images, :name, unique: true
  end
end
