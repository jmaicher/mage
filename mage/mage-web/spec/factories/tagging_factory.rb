FactoryGirl.define do
  factory :backlog_item_tagging do
    association :tag
    association :backlog_item
  end
end

