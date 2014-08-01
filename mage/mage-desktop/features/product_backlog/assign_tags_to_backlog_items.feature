Feature: Assign Tags to Backlog Items

  Background:
    Given I am the Product Owner
    And I sign in to my account
    And I go to the Product Backlog

  @javascript
  Scenario: Create Backlog Item with Tags
    When I follow the link to create a new Product Backlog Item
    And I create a Product Backlog Item with tags
    Then I should see a confirmation message
    And I should see the tags which I've associated to the Backlog Item
