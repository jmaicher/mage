FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foo-#{n}@bar.baz" }
    sequence(:name) { |n| "Test User #{n}" }
    password "top_secret"
    password_confirmation "top_secret"
  end
end

