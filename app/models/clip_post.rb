class ClipPost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  acts_as_taggable

  scope :clip_created_at, -> { order(clip_created_at: :desc) }
  scope :created_at, -> { order(created_at: :desc) }
  scope :most_views, -> { order(views: :desc) }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
