module PostMacros
  def post_at(clip_post,url)
    visit new_clip_post_path
    sleep(2)
    fill_in 'clip_url', with: url
    fill_in 'content_title', with: clip_post.content_title
    fill_in 'tag_list', with: '自由タグ'
    click_button '投稿する'
  end
end