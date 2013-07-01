Feature: Examine kanji in an entry
  As a dictionary user
  I want to look in detail at the kanji in an entry
  So that I can learn more about them and study them

  Background:
    Given the admin has imported a small edict database

  Scenario:
    Given that I have searched for "total"
    When I view the result for "『る"
    Then I should see "しめる"
