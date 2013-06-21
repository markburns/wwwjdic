Given(/^that I have searched for "([^"]*)"$/) do |query|
  visit "/word-search"
  current_path.should == "/word-search"
  fill_in("query", :with => query)
  click_button "search"
end
