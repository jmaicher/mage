# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_assignment do
    backlog_item nil
    sprint_backlog nil
    task nil
  end
end
