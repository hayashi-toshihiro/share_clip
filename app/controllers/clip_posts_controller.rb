class ClipPostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show get_clip]

  def index
    # タグでの検索
    @clip_posts = if (tag_name = params[:tag_name])
                    ClipPost.with_tag(tag_name).page(params[:page]).per(10)
                  elsif (tag_name = params[:tag_game])
                    ClipPost.with_game(tag_name).page(params[:page]).per(10)
                  elsif (tag_name = params[:tag_streamer])
                    ClipPost.with_streamer(tag_name).page(params[:page]).per(10)
                  else
                    ClipPost.all.page(params[:page]).per(10)
                  end

    # 投稿の並び替え
    @clip_posts = if params[:clip_created_at]
                    @clip_posts.clip_created_at
                  elsif params[:most_views]
                    @clip_posts.most_views
                  elsif params[:created_at]
                    @clip_posts.created_at
                  else
                    @clip_posts.all.order(created_at: :desc)
                  end
  end

  def show
    @clip_post = ClipPost.find(params[:id])
    @comment = Comment.new
    @comments = @clip_post.comments.includes(:user).order(created_at: :desc)
    render layout: 'compact'
  end

  def new
    @clip_post = ClipPost.new(
      thumbnail: "https://clips-media-assets2.twitch.tv/ZVRdGDcuY5vZ5865K5yDqw/AT-cm%7CZVRdGDcuY5vZ5865K5yDqw-preview-480x272.jpg",
      streamer: "赤見かるび",
      title: "爆速一般通過SHAKA",
      clip_created_at: "07/18 20:51:57",
      views: 327_951,
      content_title: "",
      tag_list: [""],
      embed_url: "https://clips.twitch.tv/embed?clip=BumblingShinyEndiveVoHiYo-G4qhbaXZCTBN3WXp",
      streamer_image: "https://static-cdn.jtvnw.net/jtv_user_pictures/f5ba0ca0-2187-41ea-b7bb-d0457b1dba0e-profile_image-300x300.png"
    )
  end

  def edit
    @preview_post = ClipPost.find(params[:id])
    @clip_post = ClipPost.find(params[:id])
  end

  def create
    @clip_post = current_user.clip_posts.new(clip_post_params)
    if @clip_post.valid?
      # Twitch APIで引っ張り出したデータを保存する。
      data = TwitchApi.new.get_clip(clip_post_params[:url])
      clip_data = data["data"].first
      game_data = TwitchApi.new.get_game_name(clip_data["game_id"])
      streamer_data = TwitchApi.new.get_streamer_image(clip_data["broadcaster_id"])
      streamer_color_data = TwitchApi.new.get_streamer_color(clip_data["broadcaster_id"])
      # データを代入しセーブ
      @clip_post.assign_attributes(set_clip_post_attribute(clip_data, game_data, streamer_data))

      create_image_game(game_data)
      create_image_streamer(streamer_data, clip_data, streamer_color_data)

      if @clip_post.save
        redirect_to clip_posts_path, success: "投稿したヨ"
      else
        render :new, error: "失敗しちゃったヨ"
      end
    else
      redirect_to new_clip_post_path, danger: "クリップが見つからないヨ"
    end
  end

  def update
    @clip_post = ClipPost.find(params[:id])
    if @clip_post.update(clip_post_params)
      redirect_to @clip_post, success: '変更できたヨ'
    else
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
    @clip_posts = if params[:clip_created_at]
                    ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).page(params[:page]).per(10).without_count.clip_created_at
                  elsif params[:most_views]
                    ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).page(params[:page]).per(10).without_count.most_views
                  elsif params[:created_at]
                    ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).page(params[:page]).per(10).without_count.created_at
                  else
                    ClipPost.where(id: current_user.likes.pluck(:clip_post_id)).page(params[:page]).per(10).without_count.order(created_at: :desc)
                  end
  end

  def get_clip
    preview_post = ClipPost.new
    # TwitchApiからデータを取り出す
    data = TwitchApi.new.get_clip(clip_post_params[:url])
    clip_data = data["data"].first
    game_data = TwitchApi.new.get_game_name(clip_data["game_id"])
    streamer_data = TwitchApi.new.get_streamer_image(clip_data["broadcaster_id"])
    # preview_postに全てのデータを代入
    preview_post.assign_attributes(set_clip_post_attribute(clip_data, game_data, streamer_data))
    respond_to do |format|
      format.js { render 'get_clip.js.erb', locals: { preview_post: preview_post } }
    end
  end

  def create_image_game(game_data)
    image = Image.new(name: game_data["data"].first["name"],
                      image_url: game_data["data"].first["box_art_url"].sub('{width}', '144').sub('{height}', '192'),
                      image_id: game_data["data"].first["id"])

    return if Image.find_by(name: image.name)

    image.save
  end

  def create_image_streamer(streamer_data, clip_data, streamer_color_data)
    image = Image.new(name: clip_data["broadcaster_name"],
                      image_url: streamer_data["data"].first["profile_image_url"],
                      image_id: streamer_data["data"].first["id"],
                      image_color: streamer_color_data["data"].first["color"])

    return if Image.find_by(name: image.name)

    image.save
  end

  private

  def clip_post_params
    params.require(:clip_post).permit(:url, :thumbnail, :streamer, :title, :clip_created_at, :views, :content_title, :tag_list, :game_list, :streamer_list)
  end

  def set_clip_post_attribute(clip_data, game_data, streamer_data)
    {
      url: clip_data["url"],
      thumbnail: clip_data["thumbnail_url"],
      title: clip_data["title"],
      streamer: clip_data["broadcaster_name"],
      clip_created_at: Time.parse(clip_data["created_at"]).utc,
      views: clip_data["view_count"],
      content_title: clip_post_params[:content_title],
      tag_list: clip_post_params[:tag_list],
      game_list: game_data["data"].first["name"],
      streamer_list: [clip_post_params[:streamer_list], clip_data["broadcaster_name"]],
      embed_url: clip_data["embed_url"],
      streamer_image: streamer_data["data"].first["profile_image_url"]
    }
  end
end
