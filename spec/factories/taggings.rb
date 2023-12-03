FactoryBot.define do
  factory :tagging, class: ActsAsTaggableOn::Tagging do
    tag
    taggable { association(:clip_post) }
  end
end