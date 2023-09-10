class CreateCommentLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_likes do |t|
      t.references :user, null: false, foregin_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
    add_index :comment_likes, %i[user_id comment_id], unique: true
  end
end
