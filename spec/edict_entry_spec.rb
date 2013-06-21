#encoding: utf-8
require File.expand_path('spec/spec_helper')
require 'edict_entry'


describe EdictEntry do
  let(:attributes) do
    {:kana => 'きょう',
     :kanji => '今日',
     :english_definitions => ['today', 'hello']}
  end

  before do
    @entry = EdictEntry.new attributes
  end
  it "returns the english_definitions" do
    @entry.english_definitions.should == %w(today hello)
  end

  it "returns an array of kana" do
    @entry.kana.should == ['きょう']
  end

  it "returns an array of kanji" do
    @entry.kanji.should == '今日'
  end
end
