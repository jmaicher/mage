FactoryGirl.define do
  factory :meeting do
    name nil
    meeting_type nil
    association :initiator, factory: :table
  end
end
