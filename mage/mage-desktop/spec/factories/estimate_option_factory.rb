FactoryGirl.define do
  factory :estimate_option do
    sequence(:value) { |n| n.to_s }
  end
end
