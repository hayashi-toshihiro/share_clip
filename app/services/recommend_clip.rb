class RecommendClip
  def initialize(user)
    @user = user
  end

  def recommend_clip
    # Likeしているクリップのストリーマータグを全て取得
    like_ids = @user.likes.pluck(:clip_post_id)
    liked_clip_posts = ClipPost.where(id: like_ids)
    tags = []
    liked_clip_posts.each do |post|
      streamer_tags = post.tags_on(:streamers).pluck(:name)
      tags += streamer_tags
    end

    # タグの使用されている回数を数えて、多い順にソート
    tags_count = tags.group_by { |str| str }.transform_values(&:count)
    sorted_counts = tags_count.sort_by { |name, count| -count }

    # 未閲覧クリップを全て取り出す
    history_ids = @user.view_histories.pluck(:clip_post_id)
    unwatched_clip = ClipPost.where.not(id: history_ids)

    # 多いタグ５つを取り出し、使われている投稿を未閲覧クリップリストから全て取り出す
    tag_list = sorted_counts.take(5).map { |tag| tag[0]}
    matching_clips = unwatched_clip.tagged_with(tag_list, any: true)

    matching_clips
  end
end