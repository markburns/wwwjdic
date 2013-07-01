Feature: search
  As a user of the wwwjdic website
  I want to be able to search for Japanese words
  In order to improve my Japanese

  Background:
    Given the admin has imported a small edict database

  Scenario: Searching
    Given I am on the home page
    Then the search should work

