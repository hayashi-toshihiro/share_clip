class CreateClipPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :clip_posts do |t|
      t.references :user, null: false
      t.string :url, null: false
      t.string :embed_url
      t.string :thumbnail
      t.string :streamer
      t.string :streamer_image
      t.string :title
      t.string :clip_created_at
      t.integer :views
      t.string :content_title
      
      t.timestamps
    end
  end
end
