class ClipPostsController < ApplicationController

  def new
    @clip_post = ClipPost.new
  end

  def create
    @clip_post = current_user.clip_posts.new(clip_post_params)
    if @clip_post.save
      redirect_to clip_posts_path, success: "保存が完了しました"
    else
      render :new
    end
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def likes
  end

  def get_clip
    url = params[:url]
    data = TwitchApi.new.get_clip(url)
    clip_data = data["data"].first

    preview_post = ClipPost.new(
      thumbnail: clip_data["thumbnail_url"],
      streamer: clip_data["broadcaster_name"],
      title: clip_data["title"],
      clip_created_at: clip_data["created_at"],
      views: clip_data["view_count"],
      content_title: params[:content_title],
      tag_list: params[:tag_list]
    )
    binding.pry
  end

  private

  def clip_post_params
    params.require(:clip_post).permit(:url, :thumbnail, :streamer, :title, :clip_created_at, :views, :content_title, :tag_list)
  end
end
