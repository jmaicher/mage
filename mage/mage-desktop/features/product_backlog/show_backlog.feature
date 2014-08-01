Feature: Visualize Product Backlog

  As a Product Owner
  I want to have a simple visualization of the Product Backlog
  In order to get an overview about the product requirements

  Background:
    Given I am the Product Owner
    And I sign in to my account

  @javascript
  Scenario: Show created Backlog Items
    Given the Product Backlog Item "Show created Backlog Items"
    When I go to the Product Backlog
    Then I should see the Product Backlog Item "Show created Backlog Items"

