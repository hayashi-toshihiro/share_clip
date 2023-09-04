class ClipPostsController < ApplicationController

  def new
    @clip_post = ClipPost.new
    @preview_post = ClipPost.new(
      thumbnail: "https://clips-media-assets2.twitch.tv/ZVRdGDcuY5vZ5865K5yDqw/AT-cm%7CZVRdGDcuY5vZ5865K5yDqw-preview-480x272.jpg",
      streamer: "赤見かるび",
      title: "爆速一般通過SHAKA",
      clip_created_at: "2023-07-18T20:51:57Z",
      views: 327951,
      content_title: "デフォルト",
      tag_list: ["タグ1", "タグ2"]
    )
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

   respond_to do |format|
     format.js { render 'get_clip.js.erb', locals: { preview_post: preview_post } }
    end
  end

  private

  def clip_post_params
    params.require(:clip_post).permit(:url, :thumbnail, :streamer, :title, :clip_created_at, :views, :content_title, :tag_list)
  end
end
