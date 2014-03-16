Then(/^I should see a confirmation message$/) do
  expect(page).to have_selector ".flash-success"
end

Then(/^I should see a failure message$/) do
  expect(page).to have_selector ".validation-errors"
end
