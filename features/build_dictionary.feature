Feature: build dictionary
  As a maintainer of wwwjdic
  I want to be able to import edict
  So that users can use the website

  Scenario: Successful import
    Given I have started the redis server
    And the admin has imported a small edict database
    When I search for "ˇ"
    Then I should get multiple results for "ˇ"
