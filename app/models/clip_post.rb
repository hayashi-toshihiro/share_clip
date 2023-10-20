class ClipPost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :view_histories, dependent: :destroy

  acts_as_taggable_on :tags
  acts_as_taggable_on :streamers
  acts_as_taggable_on :games

  scope :clip_created_at, -> { order(clip_created_at: :desc) }
  scope :created_at, -> { order(created_at: :desc) }
  scope :most_views, -> { order(views: :desc) }

  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }
  scope :with_game, ->(tag_name) { joins(:games).where(tags: { name: tag_name }) }
  scope :with_streamer, ->(tag_name) { joins(:streamers).where(tags: { name: tag_name }) }

  validates :url, format: { with: /clip/, message: "クリップを貼ってネ"}
  validates :url, format: { with: /twitch\.tv/, message: I18n.t('models.clip_post.url_invalid_format') }

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def view_history(user)
    # 視聴履歴を保存する処理
    new_history = view_histories.new(user_id: user.id)
    # 既に視聴済みの場合、古い履歴を削除し新しい履歴を追加する
    if user.view_histories.exists?(clip_post_id: id)
      visited_history = user.view_histories.find_by(clip_post_id: id)
      visited_history.destroy
    end
    new_history.save
  end
end
