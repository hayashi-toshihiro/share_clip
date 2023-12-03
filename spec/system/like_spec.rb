require 'rails_helper'

RSpec.describe "Likes", type: :system do
  describe 'いいね機能のテスト' do
    let!(:user) { create(:user) }
    let!(:clip_post) { create(:clip_post) }
    before { login_as(user) }
    context 'いいねを押す' do
      it 'アイコンが変わる' do
        visit clip_posts_path
        click_on id: "like_button_#{clip_post.id}"
        expect(page).to have_content '1'
      end
      it 'いいね一覧に表示される' do
        visit clip_posts_path
        click_on id: "like_button_#{clip_post.id}"
        click_on 'いいね一覧'
        expect(page).to have_content 'コンテンツタイトル'
      end
      context '再度いいねを押す' do
        before do
          visit clip_posts_path
          click_on id: "like_button_#{clip_post.id}"
        end
        it 'いいねのアイコンが戻る' do
          click_on id: "like_button_#{clip_post.id}"
          expect(page).to have_content '0'
        end
        it 'いいね一覧に表示されなくなる' do
          click_on id: "like_button_#{clip_post.id}"
          click_on 'いいね一覧'
          expect(page).to_not have_content 'コンテンツタイトル'
        end
      end
    end
  end

  describe 'おすすめ機能のテスト' do
    let!(:user) { create(:user) }
    let!(:clip_post) { create(:clip_post) }
    let!(:recommend_clip_post) { create(:clip_post, content_title: "おすすめのクリップ") }
    before { login_as(user) }
    describe 'いいねを押す' do
      it 'おすすめに投稿が表示される' do
        visit clip_posts_path
        click_on id: "like_button_#{clip_post.id}"
        sleep(1)
        click_on 'おすすめ'
        expect(page).to have_content 'おすすめのクリップ'
      end
      it '一度閲覧したクリップは表示されない' do
        visit clip_post_path(recommend_clip_post)
        visit clip_posts_path
        click_on id: "like_button_#{clip_post.id}"
        sleep(1)
        click_on 'おすすめ'
        expect(page).to_not have_content 'おすすめのクリップ'
      end
    end
  end
end


# いいね機能のテスト
#   いいねを押す
#     アイコンが変わる
#     いいね一覧に追加されている
#     再度押すと
#       いいねのアイコンが変わる
#       いいね一覧からなくなる
# おすすめ機能のテスト
#   いいねを押す
#     おすすめに他の投稿が表示される