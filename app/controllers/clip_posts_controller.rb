class ClipPostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show get_clip]
  before_action :load_tag_data, only: %i[index new edit likes]

  def index
    # タグでの絞り込み処理(+おすすめ機能)
    @clip_posts = filtered_clip_posts.page(params[:page]).per(10)
    # 並び替え処理
    @clip_posts = ordered_clip_posts(@clip_posts)
  end

  def show
    @clip_post = ClipPost.find(params[:id])
    if logged_in?
      # 視聴履歴を保存する
      @clip_post.view_history(current_user)
    end
    @comment = Comment.new
    @comments = @clip_post.comments.includes(:user).order(created_at: :desc)

    # update_vidoeから取得した内容
    video_data = session[:video_data] || {}
    @video_id = video_data["video_id"]
    @formatted_time = video_data["formatted_time"]
    @user_name = video_data["user_name"]
  
    render layout: 'compact'
  end

  def new
    # プレビューのデフォルトを設定
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
      # Twitch APIで引っ張り出したデータを代入する。
      data = TwitchApi.new.get_clip(clip_post_params[:url])
      clip_data = data["data"].first
      game_data = TwitchApi.new.get_game_name(clip_data["game_id"])
      streamer_data = TwitchApi.new.get_streamer_image(clip_data["broadcaster_id"])
      streamer_color_data = TwitchApi.new.get_streamer_color(clip_data["broadcaster_id"])

      # @clip_postにデータを追加
      @clip_post.assign_attributes(set_clip_post_attribute(clip_data, game_data, streamer_data))

      # 画像データを取り出してImageテーブルに保存
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
    @clip_posts = ClipPost.where(id: current_user.likes.pluck(:clip_post_id))
    @clip_posts = ordered_clip_posts(@clip_posts).page(params[:page]).per(10)
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

  def update_video
    # Imageクラスからbroadcaster_idを取り出す。
    broadcaster_id = Image.find_by(name: params[:streamer_name])&.image_id
    clip_created_time = params[:clip_created_at]
    # 動画の内容をピックアップ（時間のずれデータもここで計算し取得）
    video_data = TwitchApi.new.get_archive(broadcaster_id,clip_created_time)
    video_id = video_data["data"].first["id"]
    # 秒数を〇時〇分〇秒に変換
    total_seconds = video_data["data"].first["time_difference_seconds"]
    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60

    formatted_time = format("%02dh%02dm%02ds", hours, minutes, seconds)

    user_name = video_data["data"].first["user_name"]
    # セッションを使って、リロード後もセレクトボックスの値と得たデータを保持しておき表示する。
    session[:video_data] = { video_id: video_id, formatted_time: formatted_time, user_name: user_name }
    # javascriptによって、この後showアクションを実行する
    render json: {success: true }
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
      clip_created_at: Time.parse(clip_data["created_at"]).in_time_zone("Tokyo"),
      views: clip_data["view_count"],
      content_title: clip_post_params[:content_title],
      tag_list: clip_post_params[:tag_list],
      game_list: game_data["data"].first["name"],
      streamer_list: [clip_post_params[:streamer_list], clip_data["broadcaster_name"]],
      embed_url: clip_data["embed_url"],
      streamer_image: streamer_data["data"].first["profile_image_url"]
    }
  end

  def filtered_clip_posts
    if params[:tag_name]
      set_filter("tag_name", params[:tag_name])
      ClipPost.with_tag(params[:tag_name])
    elsif params[:tag_game]
      set_filter("tag_game", params[:tag_game])
      ClipPost.with_game(params[:tag_game])
    elsif params[:tag_streamer]
      set_filter("tag_streamer", params[:tag_streamer])
      ClipPost.with_streamer(params[:tag_streamer])
    elsif params[:recommend]
      clip_posts = RecommendClip.new(current_user)
      clip_posts.recommend_clip.order("RANDOM()")
    elsif params[:reset_filter]
      session.delete(:filter)
      session.delete(:filter_value)
      ClipPost.all
    elsif session[:filter] && session[:filter_value]
      case session[:filter]
      when "tag_name"
        ClipPost.with_tag(session[:filter_value])
      when "tag_game"
        ClipPost.with_game(session[:filter_value])
      when "tag_streamer"
        ClipPost.with_streamer(session[:filter_value])
      else
        ClipPost.all
      end
    else
      ClipPost.all
    end
  end

  def set_filter(filter, value)
    session[:filter] = filter
    session[:filter_value] = value
  end

  def ordered_clip_posts(clip_posts)
    sort_order = params[:order] || session[:sort_order] || "created_at"
    session[:sort_order] = sort_order
    case sort_order
    when "clip_created_at"
      @clip_posts.clip_created_at
    when "most_views"
      @clip_posts.most_views
    when "created_at"
      @clip_posts.created_at
    else
      @clip_posts.all.order(created_at: :desc)
    end
  end
end
