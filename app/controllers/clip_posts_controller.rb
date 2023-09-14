class ClipPostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show get_clip]

  def new
    @clip_post = ClipPost.new(
      thumbnail: "https://clips-media-assets2.twitch.tv/ZVRdGDcuY5vZ5865K5yDqw/AT-cm%7CZVRdGDcuY5vZ5865K5yDqw-preview-480x272.jpg",
      streamer: "赤見かるび",
      title: "爆速一般通過SHAKA",
      clip_created_at: "07/18 20:51:57",
      views: 327951,
      content_title: "",
      tag_list: [""],
      embed_url: "https://clips.twitch.tv/embed?clip=BumblingShinyEndiveVoHiYo-G4qhbaXZCTBN3WXp"
    )
  end

  def create
    @clip_post = current_user.clip_posts.new(clip_post_params)
    if @clip_post.valid?

      # Twitch APIで引っ張り出したデータを保存する。
      data = TwitchApi.new.get_clip(clip_post_params[:url])

      clip_data = data["data"].first
  
      # game_nameを取り出す
      game_data = TwitchApi.new.get_game_name(clip_data["game_id"])
      game_name = game_data["data"].first
      
      @clip_post.url = clip_data["url"]
      @clip_post.thumbnail = clip_data["thumbnail_url"]
      @clip_post.streamer = clip_data["broadcaster_name"]
      @clip_post.title = clip_data["title"]
      @clip_post.clip_created_at = Time.parse(clip_data["created_at"]).strftime("%m/%d %H:%M:%S")
      @clip_post.views = clip_data["view_count"]
      @clip_post.content_title = clip_post_params[:content_title]
      @clip_post.tag_list = [clip_data["broadcaster_name"],game_name["name"],clip_post_params[:tag_list]]
      @clip_post.embed_url = clip_data["embed_url"]
  
      if @clip_post.save
        redirect_to clip_posts_path, success: "投稿したヨ"
      else
        render :new, error: "失敗しちゃったヨ"
      end
    else
      redirect_to new_clip_post_path, danger: "クリップが見つからないヨ"
    end
  end

  def index
    # タグでの検索
    @clip_posts = if (tag_name = params[:tag_name])
                    ClipPost.with_tag(tag_name)
                  else
                    ClipPost.all
                  end

    # 投稿の並び替え
    if params[:clip_created_at]
      @clip_posts = @clip_posts.clip_created_at
    elsif params[:most_views]
      @clip_posts = @clip_posts.most_views
    elsif params[:created_at]
      @clip_posts = @clip_posts.created_at
    else
      @clip_posts = @clip_posts.all.order(created_at: :desc)
    end
  end

  def show
    @clip_post = ClipPost.find(params[:id])
    @comment = Comment.new
    @comments = @clip_post.comments.includes(:user).order(created_at: :desc)
    render :layout => 'compact'
  end

  def edit
    @preview_post = ClipPost.find(params[:id])
    @clip_post = ClipPost.find(params[:id])
  end

  def update
    @clip_post = ClipPost.find(params[:id])
    if @clip_post.update(clip_post_params)
      redirect_to @clip_post, success: '変更できたヨ'
    else
      puts @clip_post.errors.full_messages
      @preview_post = @clip_post
      flash.now[:danger] = "変更できなかったヨ"
      render :edit
    end
  end

  def destroy
    clip_post = ClipPost.find(params[:id])
    clip_post.destroy!
    redirect_to clip_posts_path, success: "削除できたヨ"
  end

  def likes
    if params[:clip_created_at]
      @clip_posts = ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).clip_created_at
    elsif params[:most_views]
      @clip_posts = ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).most_views
    elsif params[:created_at]
      @clip_posts = ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).created_at
    else
      @clip_posts = ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).order(created_at: :desc)
    end
  end

  def get_clip
    url = params[:url]
    data = TwitchApi.new.get_clip(url)
    clip_data = data["data"].first
    
    game_data = TwitchApi.new.get_game_name(clip_data["game_id"])
    game_name = game_data["data"].first

    preview_post = ClipPost.new(
      thumbnail: clip_data["thumbnail_url"],
      streamer: clip_data["broadcaster_name"],
      title: clip_data["title"],
      clip_created_at: Time.parse(clip_data["created_at"]).strftime("%m-%d %H:%M:%S"),
      views: clip_data["view_count"],
      content_title: params[:content_title],
      tag_list: [clip_data["broadcaster_name"],game_name["name"],params[:tag_list]],
      embed_url: clip_data["embed_url"]
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
