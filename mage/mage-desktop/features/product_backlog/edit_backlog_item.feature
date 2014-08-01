Feature: Update Product Backlog Items

  As a Product Owner
  I want to edit Product Backlog Items
  in order to reflect changes to already captured requirements

  Background:
    Given I am the Product Owner
    And the Product Backlog Item "Update Product Backlog Items"
    Given I sign in to my account
    And I go to the Product Backlog
    When I follow the link to edit the Product Backlog Item "Update Product Backlog Items"

  @javascript
  Scenario: Update PBIs with basic information
    When I update the basic information of the Product Backlog Item
    Then I should see a confirmation message

