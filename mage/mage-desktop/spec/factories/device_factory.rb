
FactoryGirl.define do
  factory :device, aliases: [:table] do
    device_type :table
    sequence(:name) { |n| "Table #{n}" }

    factory :board do
      device_type :board
      sequence(:name) { |n| "Board #{n}" }
    end 
  end
end
