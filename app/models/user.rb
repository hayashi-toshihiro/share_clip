class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :clip_posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_clip_posts, through: :likes, source: :clip_posts

  validates :password, confirmation: true

  def own?(object)
    id == object.user_id
  end
end
