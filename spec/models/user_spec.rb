require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it '正しい値ではエラーが出ない' do
      user = create(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
    it 'emailが同じものだとエラーが出る'
    it 'emailの入力がないとエラーが出る'
    it 'passwordの入力がないとエラーが出る'
    it 'passwordが一致していないとエラーが出る'
  end
end
