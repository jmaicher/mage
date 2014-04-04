FactoryGirl.define do

  factory :idea do
    sequence(:title) { |n| "Idea #{n}" }
    description "A fancy description for an awesome idea"
    association :author, factory: :user
  end

end
