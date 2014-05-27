Feature: Create Product Backlog Items

  As a Product Owner
  I want to create Product Backlog Items with basic information
  so that I can represent requirements for the product

  Background:
    Given I am the Product Owner
    And I sign in to my account
    And I go to the Product Backlog
    When I follow the link to create a new Product Backlog Item

  Scenario: Create PBIs with basic information
    When I create a Product Backlog Item with basic information
    Then I should see a confirmation message

  Scenario: Basic validation
    When I create a Product Backlog Item with invalid basic information
    Then I should see a failure message
