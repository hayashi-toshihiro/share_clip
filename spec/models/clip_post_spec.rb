require 'rails_helper'

RSpec.describe ClipPost, type: :model do
  describe 'validation' do
    it '正しい値ではエラーが出ない' do
      clip_post = create(:user)
      expect(clip_post).to be_valid
      expect(clip_post.errors).to be_empty
    end
  end
end