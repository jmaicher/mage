# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :backlog_item_tagging do
    tag nil
    backlog_item nil
  end
end
