def create_user
  create :user
end

def create_product_owner
  create_user
end

def sign_in user
  visit "/users/sign_in"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password

  click_button "Sign in"
end

Given(/^I am the Product Owner$/) do
  @user = create_product_owner
end

Given(/^I sign in to my account$/) do
  sign_in @user
end
