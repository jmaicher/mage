FactoryGirl.define do
  factory :sprint do
    goal "Awesome sprint goals are awesome"
    start_date Time.now
    end_date Time.now + 7.days
  end
end
