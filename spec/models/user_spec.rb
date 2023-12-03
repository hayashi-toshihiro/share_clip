require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    it '正しい値ではエラーが出ない' do
      user = create(:user)
      expect(user.errors).to be_empty
    end
  end
end
