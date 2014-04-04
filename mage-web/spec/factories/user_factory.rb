FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "foo-#{n}@bar.baz" }
    password "top_secret"
    password_confirmation "top_secret"
  end

end

