
FactoryGirl.define do
  factory :poker_vote do
    association :poker
    association :user
    association :option, factory: :poker_vote_option
  end
end
