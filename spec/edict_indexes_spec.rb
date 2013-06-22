#encoding: utf-8
require File.expand_path('spec/spec_helper')

describe EdictIndexes do
  include RedisHelpers
  let(:indexes){EdictIndexes.new './spec/fixtures/edict_small'}
  before(:each) { clear_redis }

  it "imports indexes for kana lookup" do
    indexes.destructive_rebuild_db! :kana
    key = "kana:なかぐろ"

    redis.keys.grep(key).length.should be > 0
    redis.smembers(key).should == ["1"]
  end



  it "imports indexes for english sentence lookup" do
    indexes.destructive_rebuild_db! :english_definitions

    key="english_definitions:repetition of kanji (sometimes voiced)"


    redis.keys.grep(key).length.should be > 0
    redis.smembers(key).should ==    %w(9 10 11 12 13 )
  end

  it "imports an array for english words" do

    indexes.destructive_rebuild_db! :english_words, :kanji

    english = redis.hgetall("entry:1")["english_words"]
    JSON.parse(english).should == %w[middle dot typographical symbol
      used between parallel terms names in katakana etc full-stop mark at mid-character
          height interpoint interword separation]

  end

  it "imports parts of speech" do
    pending

    indexes.destructive_rebuild_db! :parts_of_speech
    %w[n v adj-i adj-f aux exp n-adv pref v5u v5k vs vt
       abbr col hon io obsc pol uk].each do |pos|

         key="english_part_of_speech:#{pos}"
         redis.keys.grep(key).length.should be > 0
       end
  end

  context "importing all fields" do
    before do
      indexes.destructive_rebuild_db! :kanji, :kana, :english_definitions, :english_words
    end

    it "has symbols as well as kanji/kana" do
      keys = redis.keys.grep /repetition mark in hiragana/

      m = redis.smembers("english_definitions:repetition mark in hiragana").first

      lookup = redis.hgetall "entry:#{m}"
      JSON.parse(lookup["kanji"]).should == ["〉"]
    end


    it "generates an autocomplete list" do
      expected = %w[a above adding and as at between closure ditto dot end etc full-stop height hiragana
                  in interpoint interword kanji katakana make mark mid-character middle mixture
                  names of or parallel repetition salt separation sometimes sum sushi symbol terms to
                  total typographical used vinegar voiced どうじょう
      ]

      redis.keys.grep('auto_complete').length.should be > 0

      expected.each do |word|
        redis.zscore('auto_complete', word).should_not be_nil, word
      end
    end
  end


end
