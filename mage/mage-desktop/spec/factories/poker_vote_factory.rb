FactoryGirl.define do
  factory :poker_vote do
    association :poker_session
    association :user
    association :decision, factory: :estimate_option
    round 1
  end
end
