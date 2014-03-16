FactoryGirl.define do

  factory :user do
    email "foo@bar.baz"
    password "top_secret"
    password_confirmation "top_secret"
  end

end
