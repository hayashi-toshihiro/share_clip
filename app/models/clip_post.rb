class ClipPost < ApplicationRecord
  belongs_to :user
  has_many :likes

  acts_as_taggable
  
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
