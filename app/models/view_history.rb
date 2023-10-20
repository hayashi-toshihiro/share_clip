class ViewHistory < ApplicationRecord
  belongs_to :user
  belongs_to :clip_post
end
