FactoryBot.define do
  factory :clip_post do
    association :user
    url { 'https://clips.twitch.tv/BumblingShinyEndiveVoHiYo-G4qhbaXZCTBN3WXp' }
    embed_url { 'https://clips.twitch.tv/embed?clip=BumblingShinyEndiveVoHiYo-G4qhbaXZCTBN3WXp' }
    thumbnail { "https://clips-media-assets2.twitch.tv/z-T5YBuKoW2l2QkwTd1l6Q/40560094551-offset-12912-preview-480x272.jpg" }
    streamer { '赤見かるび' }
    streamer_image { 'https://static-cdn.jtvnw.net/jtv_user_pictures/f5ba0ca0-2187-41ea-b7bb-d0457b1dba0e-profile_image-300x300.png' }
    title { 'たる' }
    clip_created_at { '2023-08-25 15:03:08 UTC' }
    views { '94233' }
    sequence(:content_title) { |n| "コンテンツタイトル#{n}" }

    after(:create) do |clip_post|
      clip_post.tag_list.add("自由タグ")
      clip_post.streamer_list.add("#{clip_post.streamer}")
      clip_post.game_list.add("Escape from Tarkov")
      clip_post.save
    end
  end
end
  