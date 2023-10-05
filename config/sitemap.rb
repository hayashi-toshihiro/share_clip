# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.example.com"

SitemapGenerator::Sitemap.create do
  add root_path, priority: 1.0, changefreq: 'daily'

  static_page_options = { changefreq: 'monthly', priority: 0.5 }
  add(new_user_path, static_page_options)
  add(login_path, static_page_options)
  add(new_clip_post_path, static_page_options)
  add(likes_clip_posts_path, static_page_options)
  add(terms_path, static_page_options)
  add(privacy_policy_path, static_page_options)
  add(contact_success_path, static_page_options)

  add clip_posts_path, priority: 0.75, changefreq: 'daily'

  ClipPost.find_each do |clip_post|
    add clip_post_path(clip_post), :lastmod => clip_post.updated_at, :changefreq => 'weekly', :priority => 0.75
  end
end