def product_backlog
  @product_backlog ||= ProductBacklog.get_or_create
end

def create_backlog_item
  create :backlog_item
end


# --- GIVEN ---------------------------------------------------

Given(/^the Product Backlog Item "(.*?)"$/) do |title|
  @backlog_item = create(:backlog_item, title: title)
  product_backlog.insert @backlog_item
end


# --- WHEN ----------------------------------------------------

When(/^I go to the Product Backlog$/) do
  click_link "Backlog"
end

When(/^I follow the link to create a new Product Backlog Item$/) do
  click_link "New Product Backlog Item"
end

def fill_in_basic_information
  fill_in "Title", with: "A basic Product Backlog Item"
  fill_in "Description", with: "As a Product Owner I want to create PBIs in order to represent requirements"
end

When(/^I create a Product Backlog Item with basic information$/) do
  fill_in_basic_information
  click_button "Submit"
end

When(/^I create a Product Backlog Item with tags$/) do
  @tags = ["tag 1", "tag 2"]

  fill_in_basic_information
  fill_in "Tags", with: @tags.join(",")

  click_button "Submit"
end

When(/^I create a Product Backlog Item with invalid basic information$/) do
  # Not title -> invalid!
  fill_in "Title", with: "" 
  fill_in "Description", with: "As a Product Owner I want to create PBIs in order to represent requirements"

  click_button "Submit"
end


When(/^I follow the link to edit the Product Backlog Item "(.*?)"$/) do |title|
  # TODO: click link for PBI with given title
  click_link @backlog_item.title
  click_link "Edit Backlog Item"
end

When(/^I update the basic information of the Product Backlog Item$/) do
  fill_in_updated_information
  click_button "Save changes"
end

def fill_in_updated_information
  fill_in "Title", with: "An updated Product Backlog Item"
  fill_in "Description", with: "As a Product Owner I want to edit PBIs in order to reflect changes to already captured requirements"
end


# --- THEN ----------------------------------------------------

Then(/^I should see the Product Backlog Item "(.*?)"$/) do |title|
  expect(page).to have_content title
end

Then(/^I should see the tags which I've associated to the Backlog Item$/) do
  @tags.each do |tag|
    expect(page).to have_content tag
  end
end
