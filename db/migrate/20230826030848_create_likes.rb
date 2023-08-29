class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foregin_key: true
      t.references :clip_post, null: false, foreign_key: true

      t.timestamps
    end
    add_index :likes, %i[user_id clip_post_id], unique: true
  end
end
