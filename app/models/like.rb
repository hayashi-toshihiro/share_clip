class Like < ApplicationRecord
  belongs_to :clip_post
  belongs_to :user
end
