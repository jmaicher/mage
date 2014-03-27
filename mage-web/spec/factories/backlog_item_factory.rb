FactoryGirl.define do

  factory :backlog_item do
    sequence(:title) { |n| "Backlog item #{n}" }
    description "A fancy description for an awesome backlog item"

    factory :product_backlog_item do
      association :backlog, factory: :product_backlog    
    end

    factory :backlog_item_with_tags do
      ignore do
        tag_count 3
      end

      after :create do |item, evaluator|
        create_list(:backlog_item_tagging, evaluator.tag_count, backlog_item: item)
      end
    end


  end

end
