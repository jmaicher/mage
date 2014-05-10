
FactoryGirl.define do
  factory :device do
    factory :table do
      sequence(:name) { |n| "Table #{n}" }
      type :table
    end

    factory :board do
      type :board
      sequence(:name) { |n| "Board #{n}" }
    end 
  end
end
