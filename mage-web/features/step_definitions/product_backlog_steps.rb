def create_backlog_item
  create :backlog_item
end


# --- GIVEN ---------------------------------------------------

Given(/^the Product Backlog Item "(.*?)"$/) do |title|
  ProductBacklog.get.insert create(:backlog_item, title: title)
end


# --- WHEN ----------------------------------------------------

When(/^I go to the Product Backlog$/) do
  click_link "Backlog"
end

When(/^I follow the link to create a new Product Backlog Item$/) do
  click_link "New Product Backlog Item"
end

When(/^I create a Product Backlog Item with basic information$/) do
  fill_in "Title", with: "A basic Product Backlog Item"
  fill_in "Description", with: "As a Product Owner I want to create PBIs in order to represent requirements"

  click_button "Submit"
end

When(/^I create a Product Backlog Item with invalid basic information$/) do
  # Not title -> invalid!
  fill_in "Title", with: "" 
  fill_in "Description", with: "As a Product Owner I want to create PBIs in order to represent requirements"

  click_button "Submit"
end


# --- THEN ----------------------------------------------------

Then(/^I should see the Product Backlog Item "(.*?)"$/) do |title|
  expect(page).to have_content title
end
