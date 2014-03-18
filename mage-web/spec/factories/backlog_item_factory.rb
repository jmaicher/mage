FactoryGirl.define do

  factory :backlog_item do
    sequence(:title) { |n| "Backlog item #{n}" }
    description "A fancy description for an awesome backlog item"

    factory :product_backlog_item do
      association :backlog, factory: :product_backlog    
    end
  end

end
