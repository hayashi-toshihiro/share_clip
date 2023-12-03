require 'rails_helper'

RSpec.describe "ClipPosts", type: :system do
  let(:user) { create(:user) }

  describe 'プレビューのテスト' do
    before { login_as(user) }
    context 'フォームを正しく入力' do
      it '正常にプレビュー画面が変わる' do
        sleep(2)
        visit new_clip_post_path
        fill_in 'clip_url', with: clip_post.url
        click_button '表示'
        expect(page).to have_selector("img[src*='#{clip_post.thumbnail}']")
      end
      it 'フォームの自動入力がされる' do
        sleep(2)
        visit new_clip_post_path
        fill_in 'clip_url', with: clip_post.url
        click_button 'プレビュー'
        expect(page).to have_content clip_post.streamer
      end
    end
    context 'クリップのurl以外を入力' do
      it 'プレビューが失敗する' do
        sleep(2)
        visit new_clip_post_path
        fill_in 'clip_url', with: "https://www.twitch.tv/videos/1970746893"
        click_button 'プレビュー'
        expect(page).to have_content 'クリップを貼ってネ'
      end
    end
  end

  describe '投稿のテスト' do
    before { login_as(user) }
    context 'フォームを正しく入力' do
      context 'ゲームタグと配信者タグをつけて投稿' do
        it '正常に投稿、ゲームタグが追加される' do
          sleep(2)
          visit new_clip_post_path
          fill_in 'clip_url', with: clip_post.url
          click_button '投稿する'
          expect(page).to have_selector("img[src*='#{clip_post.thumbnail}']")
          expect(page).to have_content clip_post.streamer
          expect(page).to have_selector("img[src*='https://static-cdn.jtvnw.net/ttv-boxart/491931_IGDB-144x192.jpg']")
        end
      end
      context '配信者タグを追加し投稿' do
        it '正常に投稿、追加で配信者タグが表示' do
          sleep(2)
          visit new_clip_post_path
          fill_in 'clip_url', with: clip_post.url
          fill_in 'streamer_list', with: 'fps_shaka'
          click_button '投稿する'
          expect(page).to have_selector("img[src*='#{clip_post.thumbnail}']")
          expect(page).to have_content 'fps_shaka'
        end
      end
      context '自由タグを追加し投稿' do
        it '正常に投稿、自由タグも表示' do
          sleep(2)
          visit new_clip_post_path
          fill_in 'clip_url', with: clip_post.url
          fill_in 'tag_list', with: '自由'
          click_button '投稿する'
          expect(page).to have_selector("img[src*='#{clip_post.thumbnail}']")
          expect(page).to have_content '自由'
        end
      end
    end
    context 'クリップではないurl' do
      it '投稿が失敗する' do
        sleep(2)
        visit new_clip_post_path
        fill_in 'clip_url', with: "https://www.twitch.tv/videos/1970746893"
        click_button '投稿する'
        expect(page).to have_content 'クリップが見つからないヨ'
      end
    end
  end

  describe '表示に関するテスト' do
    describe 'ログイン済み' do
      before { login_as(user) }
      context '自分の投稿' do
        it '編集ボタンと削除ボタンが表示される' do
          sleep(2)
          clip_post = create(:clip_post, user: user)
          visit clip_posts_path
          expect(page).to have_link(nil, href: edit_clip_post_path(clip_post))
        end
      end
      context '他人の投稿' do
        it '編集ボタンと削除ボタンは表示されない' do
          sleep(2)
          another_user = create(:user)
          clip_post = create(:clip_post, user: another_user)
          visit clip_posts_path
          expect(page).to_not have_link(nil, href: edit_clip_post_path(clip_post))
        end
      end
    end
    describe '未ログイン' do
      it '編集、削除、いいねボタンは表示されない' do
        clip_post = create(:clip_post, user: user)
        visit clip_posts_path
        expect(page).to_not have_link(nil, href: edit_clip_post_path(clip_post))
      end
    end
  end

  describe '編集のテスト' do
    before { login_as(user) }
    context 'フォームを編集' do
      it 'プレビューを押すとプレビューができる' do
        sleep(2)
        clip_post = create(:clip_post, user: user)
        visit edit_clip_post_path(clip_post)
        fill_in 'streamer_list', with: 'fps_shaka'
        click_button '表示'
        expect(page).to have_content 'fps_shaka'
      end
      it '正常に投稿ができる' do
        sleep(2)
        clip_post = create(:clip_post, user: user)
        visit edit_clip_post_path(clip_post)
        fill_in 'streamer_list', with: 'fps_shaka'
        click_button '投稿する'
        expect(page).to have_content 'fps_shaka'
      end
    end
    context '他のユーザーの編集ページにアクセス' do
      it 'アクセスが失敗する' do
        another_user = create(:user)
        clip_post = create(:clip_post, user: another_user)
        visit edit_clip_post_path(clip_post)
        expect(page).to have_content 'ダメだヨ'
      end
    end
  end

  describe '削除のテスト' do
    before { login_as(user) }
    it '削除ボタンで削除が実行される' do
      sleep(2)
      clip_post = create(:clip_post, user: user)
      visit clip_posts_path
      find('.fa-trash-can').click
      expect(page).to have_content '削除できたヨ'
    end
  end

  describe '並び替えのテスト' do
    before do
      login_as(user)
      create(:clip_post, clip_created_at: '2023-08-02 15:03:08 UTC', views: 10000, content_title: '投稿1', user: user)
      sleep(1)
      create(:clip_post, clip_created_at: '2023-08-01 15:03:08 UTC', views: 1000, content_title: '投稿2', user: user)
      sleep(1)
      create(:clip_post, clip_created_at: '2023-08-03 15:03:08 UTC', views: 100, content_title: '投稿3', user: user)
    end
    context '時系列順をクリック' do
      it 'clip_created_at順に並ぶ' do
        sleep(2)
        visit clip_posts_path
        click_on '時系列順'
        expect(page).to have_content(/投稿3.*投稿1.*投稿2/m)
      end
    end
    context '再生順をクリック' do
      it 'views順に並ぶ' do
        sleep(2)
        visit clip_posts_path
        click_on '再生数順'
        expect(page).to have_content(/投稿1.*投稿2.*投稿3/m)
      end
    end
    context '投稿順をクリック' do
      it 'created_at順に並ぶ' do
        sleep(2)
        visit clip_posts_path
        click_on '投稿順'
        expect(page).to have_content(/投稿3.*投稿2.*投稿1/m)
      end
    end
  end
end
