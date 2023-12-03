class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :clip_posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_clip_posts, through: :likes, source: :clip_post
  has_many :comments, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :comment_like_comments, through: :comment_likes, source: :comment
  has_many :view_histories, dependent: :destroy

  validates :email, uniqueness: true, presence: true
  validates :password, confirmation: true
  validates :password, presence: true, length: { minimum: 4 }

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

  def comment_like(comment)
    comment_like_comments << comment
  end

  def comment_unlike(comment)
    comment_like_comments.destroy(comment)
  end

  def comment_like?(comment)
    comment_like_comments.include?(comment)
  end
end
