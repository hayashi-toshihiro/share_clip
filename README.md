# [ClipReactor](https://www.clipreactor.com)
![Alt text](images/%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E7%94%BB%E5%83%8F.png)

## サービス概要
「Clip Reactor」は、Twtichのお気に入りクリップを他人と共有できるサービスです。
<details>
<summary>Twitchとは</summary>
Twitchは、ゲーム配信を中心にした生配信ができるプラットフォームです。さまざまなストリーマーがゲームプレイや雑談配信などをコンテンツとして提供し、視聴者はコメントでコミュニケーションをとったり、ギフトなどでサポートができる、生配信に特化した動画配信サイトです。
</details>

<details>
<summary>クリップとは</summary>
Twitchのクリップ機能とは、視聴者が特定の瞬間を簡単に切り抜き短い動画を作成できるツールです。クリップを作成すると短い動画として保存されコメントにurlを貼ることで共有することができます。
</details></br>

サービスURL：[https://www.clipreactor.com](https://www.clipreactor.com)

ゲストログイン用ID：example@test.com  
パスワード: password

## サービスコンセプト
Twitchプラットフォームでは、面白いクリップであっても再生数が伸びずにランキング等で埋もれてしまって見つけ出せないという課題があり、
個人が選りすぐったクリップを共有できる環境が必要だと思いtwitchクリップ共有サービスとしてこのアプリを作成しました。
また、クリップを見つけやすいように時系列順で検索ができたり、クリップに複数の配信者が登場する場合には、他の配信者の視点からもクリップを見られるようにすることで、
さらにクリップを楽しめるような環境にしました。

## 主な機能

### メイン機能
|クリップの閲覧|クリップの投稿・検索|
|:----------|:----------|
|<video src="images/%E5%8B%95%E7%94%BB%E4%B8%80%E8%A6%A7.mp4" controls title="Title"></video>|<video src="images/%E3%82%AF%E3%83%AA%E3%83%83%E3%83%97%E3%81%AE%E6%8A%95%E7%A8%BF%E3%83%BB%E6%A4%9C%E7%B4%A2.mp4" controls title="Title"></video>|
|各ユーザーが投稿した様々なクリップを一覧で閲覧し視聴することができます。ユーザー登録をすることで、Likeやコメントも投稿できます。|投稿の際、ストリーマー名タグ・ゲーム名タグは自動で登録され、タグの追加も自動保管で簡単に追加できます。タグによる検索も可能で、併用して並び替えも利用できます。|

|一方その頃機能|おすすめ機能|
|:--------|:--------|
|<video src="images/%E4%B8%80%E6%96%B9%E3%81%9D%E3%81%AE%E9%A0%83%EF%BC%92.mp4" controls title="Title"></video>|<video src="images/%E3%81%8A%E3%81%99%E3%81%99%E3%82%81%E6%A9%9F%E8%83%BD.mp4" controls title="Title"></video>|
|クリップの作成時間を元に、他の配信者の視点からその場面を見ることができます。この機能の利用には配信のアーカイブが残っている必要があります。|Likeした投稿のタグを元に、タグがついた投稿を未視聴のものからランダムで取得しておすすめします。|

### その他機能
- ユーザー登録機能
- アバター画像ランダム設定機能
- コメントに対するLike機能

### 今後実装を考えている機能
- 「一方その頃機能」の精度向上
- youtubeへの対応
- おすすめ機能の改善

## 使用技術
### フロントエンド
- HTML
- SCSS
- JQuery

### バックエンド
- Ruby 2.6.6
- Ruby on Rails 6.1.7.3
- PostgreSQL
- twitch API

### インフラ
- Heroku
- AWS S3

### 主なGem
- sorcery
- acts-as-taggble-on
- romaji
- levenshtein-ffi
- sitemap_generator
- aws-sdk
- meta-tags


### 画面推移図  
https://www.figma.com/files/drafts?fuid=1247421629732133027

### ER図
![Alt text](images/ER%E5%9B%B3.png)
