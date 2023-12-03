require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:tagging) { create(:tagging) }
  it "テスト" do
    expect(tagging).to be_valid
  end
end