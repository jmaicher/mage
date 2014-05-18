
FactoryGirl.define do
  factory :poker do
    association :meeting
    association :backlog_item  
  end
end
