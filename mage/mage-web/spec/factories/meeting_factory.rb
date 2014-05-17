FactoryGirl.define do
  factory :meeting do
    name nil
    meeting_type nil
    association :initiator, factory: :table

    factory :meeting_with_participants do
      ignore do
        number 3
      end

      after :build do |meeting, evaluator|
        build_list(:meeting_participation, evaluator.number, meeting: meeting)
      end

      after :create do |meeting, evaluator|
        create_list(:meeting_participation, evaluator.number, meeting: meeting)
      end
    end
  end

end
