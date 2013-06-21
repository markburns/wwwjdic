require './spec/spec_helper'
require './app/data_access/auto_complete'
require './app/data_access/redis_helpers'

load './lib/tasks/dictionary.rake'

describe AutoComplete do
  before do
    Rake::Task['db:destructive_rebuild'].invoke('spec/fixtures/edict_small', warn=false)
  end

  it "finds english entries" do
    results = AutoComplete.find('in')
    results.should == ["in", "interpoint (interword separation)", "interpoint", "interword"]
  end

  it "handles spaces" do
    results = AutoComplete.find('repetition mark')
    results.should == ['repetition mark in hiragana', 'repetition mark in katakana']
  end
end
