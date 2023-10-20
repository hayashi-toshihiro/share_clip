class CreateViewHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :view_histories do |t|
      t.references :user, null: false
      t.references :clip_post, null: false

      t.timestamps
    end
  end
end
