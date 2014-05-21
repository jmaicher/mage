FactoryGirl.define do

  factory :meeting_participation, aliases: [:participating_user] do
    association :meeting
    association :meeting_participant, factory: :user

    factory :participating_device do
      association :meeting_participant, factory: :device
    end
  end

end
