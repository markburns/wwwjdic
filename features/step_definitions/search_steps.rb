#encoding: utf-8
Given(/^that I have searched for "([^"]*)"$/) do |query|
  visit "/word-search"
  current_path.should == "/word-search"
  fill_in("query", :with => query)
  click_button "search"
end

def expect_search query, result
  fill_in "query", with: query
  click_button "search"
  #within "#results" do
    page.should have_content result
  #end
end

Then(/the search should work/) do
  expect_search "どうのじてん", "repetition of kanji (sometimes voiced)"
  expect_search "『る", "to make sushi adding a mixture of vinegar and salt"
  expect_search "repetition mark in hiragana", "〉"
end
