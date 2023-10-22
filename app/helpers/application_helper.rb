module ApplicationHelper
  def default_meta_tags
    {
      site: 'twitchクリップ共有',
      title: 'ツイッチの動画をシェア検索や同時視聴や他視点検索アーカイブ検索でクリップをもっと楽しもう！',
      reverse: true,
      separator: '|', # Webサイト名とページタイトルを区切るために使用されるテキスト
      description: 'twitchクリップの他視点のアーカイブ検索ができるクリップ共有サイトです。イベント検索、配信者検索で、まだ見ぬおもしろクリップを共有しましょう!',
      keywords: 'ページキーワード', # キーワードを「,」区切りで設定する
      noindex: !Rails.env.production?,
      icon: [ # favicon、apple用アイコンを指定する
        { href: image_url('hasami-icon.ico') },
        { href: image_url('hasami-icon.ico'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' }
      ],
      og: {
        site_name: 'twitchクリップ共有',
        title: 'ツイッチの動画をシェア検索して視聴者の反応も楽しもう！',
        description: 'お気に入りクリップを共有しましょう！ゲーム検索・イベント名検索で埋もれた爆笑クリップも発見できるかも！？',
        type: 'website',
        image: image_url('hasami.jpg'),
        locale: 'ja_JP'
      }
    }
  end
end
