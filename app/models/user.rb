class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :clip_posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_clip_posts, through: :likes, source: :clip_post

  validates :password, confirmation: true

  def own?(object)
    id == object.user_id
  end

  def like(clip_post)
    like_clip_posts << clip_post
  end

  def unlike(clip_post)
    like_clip_posts.destroy(clip_post)
  end

  def like?(clip_post)
    like_clip_posts.include?(clip_post)
  end
end
