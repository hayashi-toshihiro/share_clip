require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create(:tag) }
  describe "テスt" do
    it "テスト" do
     expect(tag).to be_valid
    end
  end
end