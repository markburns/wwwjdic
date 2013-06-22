require './spec/spec_helper'

describe AutoComplete do
  before do
    load './lib/tasks/dictionary.rake'
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
