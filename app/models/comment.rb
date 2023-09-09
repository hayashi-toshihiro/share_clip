class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :clip_post

  has_many :comment_likes, dependent: :destroy
  has_many :comment_like_users, through: :comment_likes, source: :user

  def comment_liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
