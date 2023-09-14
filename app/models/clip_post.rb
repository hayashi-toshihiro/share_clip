class ClipPost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  acts_as_taggable

  scope :clip_created_at, -> { order(clip_created_at: :desc) }
  scope :created_at, -> { order(created_at: :desc) }
  scope :most_views, -> { order(views: :desc) }

  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: {name: tag_name}) }

  validates :url, format: { with: /twitch\.tv/, message: "は正しい形式ではありません" }
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
