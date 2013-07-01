#encoding: utf-8
require File.expand_path('spec/spec_helper')

describe EdictEntry do
  let(:attributes) do
    {:kana => ['きょう'].to_json,
     :kanji => ["今日"].to_json,
     :english_definitions => ['today', 'hello'].to_json}
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
