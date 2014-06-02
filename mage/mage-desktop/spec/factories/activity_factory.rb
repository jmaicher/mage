FactoryGirl.define do
  factory :activity do
    key "activity.new"
    association :actor, factory: :user
  end
end
