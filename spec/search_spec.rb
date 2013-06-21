#encoding: utf-8
require File.expand_path('spec/spec_helper')
require 'active_support/core_ext/hash'
require './app/models/search'
require './app/data_access/tokenizer'

describe Search do
  let(:today) do
    {
      "kanji"               => "今日",
      "kana"                => ["きょう"],
      "english_definitions" => ["today", "this day", "present"],
      "english_words"       => ["today", "this", "day", "present"] 
    }
  end

  let(:today_json) do
    {
      :kanji               => '今日',
      :english_definitions => ['today', 'this day', 'present'],
      :english_words       => ['today', 'this', 'day', 'present'],
      :kana                => ['きょう']
    }.with_indifferent_access
  end

  let(:hello_json) do 
    {
      :kanji               => '今日は',
      :english_definitions => ['hello', 'good morning'],
      :english_words       => ['hello', 'good', 'morning'],
      :kana                => ['こんにちは']
    }
  end

  before do
    @redis = stub 'Redis'
    Search.stub(:redis).and_return @redis
    Search.any_instance.stub(:redis).and_return @redis
  end

  context "successfully looking up by kanji" do
    before do
      @redis.should_receive(:smembers).with('kanji:今日').and_return ["7", "9000"]

      @redis.should_receive(:hgetall).with('entry:7').and_return today_json
      @redis.should_receive(:hgetall).with('entry:9000').and_return hello_json

      @entries = Search.find(:kanji, '今日')
    end

    it "returns multiple entries" do
      @entries.count.should == 2
    end

    it "returns the first kanji match" do
      entry = @entries.first

      entry.english_definitions.should == ['today', 'this day', 'present']
      entry.english_words.should == ['today', 'this', 'day', 'present']
      entry.kana.should == ['きょう']
      entry.kanji.should == '今日'
    end

    it "returns the last kanji match" do
      entry = @entries.last

      entry.english_definitions.should == ['hello', 'good morning']
      entry.english_words.should == ['hello', 'good', 'morning']
      entry.kana.should == ['こんにちは']
      entry.kanji.should == '今日は'
    end
  end

  it "returns nil if it doesn't find a record" do
    @redis.should_receive(:smembers).with('kanji:blah').and_return nil
    Search.find(:kanji, 'blah').should == nil
  end

  it "allows lookup by English" do
    @redis.should_receive(:smembers).with('english_words:today').and_return ["10"]
    @redis.should_receive(:hgetall).with('entry:10').and_return today_json

    Search.find(:english_words, 'today').should == [today]
  end


  it "allows lookup by Kana" do
    @redis.should_receive(:smembers).with('kana:きょう').and_return ["12"]
    @redis.should_receive(:hgetall).with('entry:12').and_return today_json
    EdictEntry.should_receive(:new).with(today_json).and_return today
    Search.find(:kana, 'きょう').should == [today]
  end

  describe "#search" do
    it "searches kanji" do
      @redis.should_receive(:smembers).at_least(:once).with('english_definitions:今日').and_return []
      @redis.should_receive(:smembers).at_least(:once).with('kana:今日').               and_return []
      @redis.should_receive(:smembers).at_least(:once).with('english_words:今日').      and_return []
      @redis.should_receive(:smembers).at_least(:once).with('kanji:今日').              and_return ["7", "2"]

      @redis.should_receive(:hgetall).with('entry:7').and_return today_json
      @redis.should_receive(:hgetall).with('entry:2').and_return hello_json

      Search.new("今日").results.length.should == 2
    end

    it "returns a full match first" do
      @redis.should_receive(:smembers).with('english_definitions:to join').and_return %w(1 2)
      @redis.should_receive(:smembers).with('english_definitions:join').and_return %w(4)

      @redis.should_receive(:hgetall).with('entry:1').and_return today_json
      @redis.should_receive(:hgetall).with('entry:2').and_return hello_json
      @redis.should_receive(:hgetall).with('entry:4').and_return hello_json


      results = Search.new("to join", :english_definitions).results
      results.should_not be_empty
    end
    context "searching english words" do
      before do

      end

      it "searches single english words" do
        @redis.should_receive(:smembers).with('english_definitions:today').and_return ["7"]
        @redis.should_receive(:smembers).with('kana:today').               and_return []
        @redis.should_receive(:smembers).with('english_words:today').      and_return []
        @redis.should_receive(:smembers).with('kanji:today').              and_return []

        @redis.should_receive(:hgetall).with('entry:7').and_return today_json

        results= Search.new("today").results
        results.length.should == 1
        result = results.first
        result.kanji.should == "今日"
        result.kana.should == ["きょう"]
        result.english_definitions.should == ["today", "this day", "present"]
        result.english_words.should == ["today", "this", "day", "present"]
      end

      it "searches multiple english words" do
        @redis.should_receive(:smembers).with('english_definitions:today hello').and_return []
        @redis.should_receive(:smembers).with('english_definitions:today').and_return ["7"]
        @redis.should_receive(:smembers).with('english_definitions:hello').and_return ["2"]


        @redis.should_receive(:hgetall).with('entry:7').and_return today_json
        @redis.should_receive(:hgetall).with('entry:2').and_return hello_json


        Search.new("today hello", :english_definitions).results.length.should == 2
      end
    end
  end
end
