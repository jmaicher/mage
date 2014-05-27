FactoryGirl.define do

  factory :product_backlog do

    factory :filled_product_backlog do
      
      ignore do
        size 3
      end

      after :create do |backlog, evaluator|
        create_list(:backlog_item, evaluator.size, backlog: backlog)
      end

    end

  end

end
