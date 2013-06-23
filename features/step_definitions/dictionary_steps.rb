Given /^the admin has imported a small edict database$/ do
  Rake::Task['db:destructive_rebuild'].invoke('./spec/fixtures/edict_small',
                                              confirm=false,
                                              environment='test')
end

When /^I search for "([^"]*)"$/ do |query|
  @results = Search.perform query
end

Then /^I should get multiple results for "([^"]*)"$/ do |arg1|
  @results.length.should be > 0
end
