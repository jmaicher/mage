FactoryGirl.define do
  factory :acceptance_criteria, :class => 'AcceptanceCriteria' do
    description "My acceptance criteria"
    done false
    association :backlog_item
  end
end
