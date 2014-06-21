FactoryGirl.define do

  factory :note do
    sequence(:title) { |n| "Note #{n}" }
    description "A fancy description for an awesome note"
    association :author, factory: :user
  end

end
