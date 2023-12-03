class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :load_tag_data
  add_flash_types :success, :info, :warning, :danger

  private

  def not_authenticated
    redirect_to login_path, danger: "ログインして欲しいナ"
  end

  def load_tag_data
    streamers_name = ClipPost.tags_on(:streamers).pluck(:name)
    @streamers_image = Image.where(name: streamers_name).index_by(&:name)
    @games = Image.where(name: ClipPost.tags_on(:games).pluck(:name))
    @tags = ClipPost.tags_on(:tags)
  end

  def correct_user
    @clip_post = current_user.clip_posts.find_by(id: params[:id])
    unless @clip_post
      redirect_back(fallback_location: clip_posts_path, flash: { danger: "ダメだヨ" } )
    end
  end
end
