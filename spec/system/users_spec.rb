require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザーの新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規登録が完了する' do
          visit new_user_path
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワードの確認', with: 'password'
          click_button 'アカウント作成'
          expect(page).to have_content '登録ありがとネ'
          expect(current_path).to eq clip_posts_path
        end
      end
      context 'emailが未入力' do
        it '登録が失敗する' do
          visit new_user_path
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワードの確認', with: 'password'
          click_button 'アカウント作成'
          expect(page).to have_content '登録失敗しちゃったヨ'
          expect(current_path).to eq users_path
        end
      end
      context 'passwordが未入力' do
        it '登録が失敗する' do
          visit new_user_path
          fill_in 'メールアドレス', with: 'email@example.com'
          click_button 'アカウント作成'
          expect(page).to have_content '登録失敗しちゃったヨ'
          expect(page).to have_field 'メールアドレス', with: 'email@example.com'
          expect(current_path).to eq users_path
        end
      end
      context '既存ユーザーのemailが一致する' do
        it '登録が失敗する' do
          visit new_user_path
          existed_user = create(:user)
          fill_in 'メールアドレス', with: 'user_1@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワードの確認', with: 'password'
          click_button 'アカウント作成'
          expect(page).to have_content '登録失敗しちゃったヨ'
          expect(current_path).to eq users_path
        end
      end
    end
    describe 'ログイン' do
      context '入力値が正常' do
        it 'ログインが成功する' do
          visit login_path
          user = create(:user)
          fill_in 'メールアドレス', with: "user_2@example.com"
          fill_in 'パスワード', with: "password"
          click_button 'ログイン'
          expect(page).to have_content 'ログインしたヨ'
          expect(page).to have_selector("img[src*='#{user.stamp_url}']")
        end
      end
      context 'emailが未入力' do
        it 'ログインに失敗する' do
          visit login_path
          user = create(:user)
          fill_in 'パスワード', with: user.password
          click_button 'ログイン'
          expect(page).to have_content 'ログイン失敗しちゃったヨ'
        end
      end
      context 'passwordが未入力' do
        it 'ログインに失敗する' do
          visit login_path
          user = create(:user)
          fill_in 'メールアドレス', with: user.email
          click_button 'ログイン'
          expect(page).to have_content 'ログイン失敗しちゃったヨ'
        end
      end
    end
  end
  describe 'ログイン後' do

  end
end