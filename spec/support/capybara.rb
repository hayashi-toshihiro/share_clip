RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome
  end
end