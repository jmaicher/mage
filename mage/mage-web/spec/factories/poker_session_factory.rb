
FactoryGirl.define do
  factory :poker_session do
    association :meeting
    association :backlog_item  
  end
end
