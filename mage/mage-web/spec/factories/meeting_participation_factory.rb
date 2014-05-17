FactoryGirl.define do

  factory :meeting_participation do
    association :meeting
    association :user
  end

end
