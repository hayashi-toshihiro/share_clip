require 'rails_helper'

RSpec.describe "Tag", type: :system do
  describe 'タグに関するテスト' do
    let(:user) { create(:user) }
    let(:clip_post) { create(:clip_post) }
    before do 
      login_as(user)
      post_at(clip_post, "https://clips.twitch.tv/BumblingShinyEndiveVoHiYo-G4qhbaXZCTBN3WXp")
    end

    describe 'タグのカテゴライズ' do
      context '３つのカテゴリでクリップを投稿' do
        it 'それぞれの場所で表示がされる' do
          within('#flush-collapseOne') do
            expect(page).to have_content('赤見かるび')
          end
          within('#flush-collapseTwo') do
            expect(page).to have_selector("img[src*='https://static-cdn.jtvnw.net/ttv-boxart/491931_IGDB-144x192.jpg']")
          end
          within('#flush-collapseThree') do
            expect(page).to have_content('自由タグ')
          end
        end
      end
    end
    
    describe 'タグでの絞り込み' do
      let(:user) { create(:user) }
      let(:clip_post) { create(:clip_post) }
      let(:clip_post_2) { create(:clip_post) }
      let(:clip_post_3) { create(:clip_post)}
      before do
        login_as(user)
        post_at(clip_post, "https://clips.twitch.tv/BumblingShinyEndiveVoHiYo-G4qhbaXZCTBN3WXp")#赤見かるび #Tarkov
        post_at(clip_post_2, "https://clips.twitch.tv/HardTawdryCheesePoooound-c0skrRtjpFINzi7n")#赤見かるび #GTA5
        post_at(clip_post_3, "https://clips.twitch.tv/BoldHonestBasenjiNerfRedBlaster-0-CkPvanHeyk1g4-")#鈴木ノリアキ #Simulator
      end
      context 'タグをクリックする' do
        it 'タグがある投稿のみが表示される' do
          visit clip_posts_path
          clik_on '赤見かるび'
          within('.col-6') do
            expect(page).to_not have_content '鈴木ノリアキ'
          end
        end
        context '絞り込みができる' do
          it 'タグの投稿のみかつ時系列順の並び替えができる'
          it 'タグの投稿のみかつ再生順の並び替えができる'
          it 'タグの投稿のみかつ投稿順の並び替えができる'
        end
      end
    end
  end
end

# タグに関するテスト
#   タグのカテゴライズ
#     ３つの種類のタグを投稿
#       それぞれの場所で表示される
#   タグでの絞り込み
#     タグをクリックで、絞り込みができる
#       絞り込みかつ並び替え
#         タグの投稿のみかつ時系列順の並び替えができる
#         タグの投稿のみかつ再生順の並び替えができる
#         タグの投稿のみかつ投稿順の並び替えができる
#