Feature: search
  As a user of the wwwjdic website
  I want to be able to search for Japanese words
  In order to improve my Japanese

  Background:
    Given the admin has imported a small edict database

  Scenario: Search for "どうのじてん"
    Given I am on the home page
    When I fill in "query" with "どうのじてん"
    And press "search"
    Then I should see "repetition of kanji (sometimes voiced)" within "#results"

    When I fill in "query" with "『る"
    And press "search"
    Then I should see "to make sushi adding a mixture of vinegar and salt" within "#results"

    Given I am on the word search page
    When I fill in "query" with "repetition mark in hiragana"
    And press "search"
    Then I should see "〉"

