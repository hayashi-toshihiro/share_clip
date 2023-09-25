# [CripReactor]

## サービス概要
Twtichのお気に入りクリップを他人と共有できるサービスです。
（クリップとは、配信サイトTwitchの配信のごく一部のみを切り取った短い動画。Twitchでは視聴者がクリップを簡単に作成できる。）

##　想定されるユーザー層
Twitchで配信を見る視聴者。

## サービスコンセプト
Twitchにはクリップという配信の見どころを切り取る便利機能があるが、
面白いクリップがあっても埋もれてしまっていたり、
自分がみたいクリップを探すのが難しかったりするため、
それらを共有するサイトを作りたいと考えました。
また、twitchのクリップ機能ではコメント等の反応ができないため、
このサイトでリアクションができ、クリップの共有が楽しくなるようにしていきたいと考えています。

## 実装を予定している機能
### MVP
* 会員登録
* ログイン、ログアウト
* 投稿クリップ一覧（閲覧数、投稿日時、クリップ作成日時での並び替え）
* クリップ投稿(APIを利用し、urlでデータを取得)
* 投稿時プレビュー表示機能
* 投稿に対するタグ（タグのカテゴライズ）
* 投稿クリップの編集、詳細、削除
* 投稿クリップの検索（カテゴリーごとで表示）
* 投稿へのいいね機能、いいね一覧
* 投稿クリップへのコメント機能、削除機能
* コメントに対してのいいね機能
* 無限スクロール（スクロールすると次の投稿が読み込まれる）
* 利用規約・プライバシーポリシー
* 独自ドメイン

### その後の機能
* googleアナリティクス
* サイドバーの固定
* お問い合わせ機能
* スマホへの対応
* レコメンド機能（おすすめの表示）
* マルチ検索・オートコンプリート（類似タグ作成しないためにも欲しい）

### 実現可能かも不確かな追加機能
* 自動でtwitchからクリップを取得(twitchのアーカイブのコメントを元に取得したい)


ーーFigmaーー
作成ページ一覧：　https://www.figma.com/files/drafts?fuid=1247421629732133027

今回編集の共有ができていませんが、Figmaの無料プランでは３ファイルまでとなっているようですので、閲覧のみでの共有となっております。


--ER図--
![Alt text](images/ER%E5%9B%B3.drawio.png)