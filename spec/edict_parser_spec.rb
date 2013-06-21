#encoding: utf-8
require './spec/spec_helper'
require './db/edict_parser'
describe EdictParser do

  def line_with_kanji_kana_mix_and_kana
    "『る [しめる] /(v1,vt) (1) to total/to sum/(2) to make sushi adding a mixture of vinegar and salt/"
  end

  def line_with_kanji
    "ˇ [なかぐろ] /(n) middle dot (typographical symbol used between parallel terms, names in katakana, etc.)/full-stop mark at mid-character height/interpoint (interword separation)/"
  end

  def line_with_just_kanji
    "《 /(n) voiced repetition mark in hiragana/"
  end

  def kana
    ["なかぐろ"]
  end

  def line_without_kanji
    "えっへん /(int) ahem/"
  end

  def english_definitions
    [
      "middle dot (typographical symbol used between parallel terms, names in katakana, etc.)",
      "full-stop mark at mid-character height",
      "interpoint (interword separation)"
    ]
  end


  describe EdictParser::KANJI do
    let(:regex) {EdictParser::KANJI}

    it "finds the kanji in a line with kanji and kana" do
      regex.match(line_with_kanji)[:kanji].should == "ˇ"
    end

    it "finds the kanji in a line with kanji but no kana" do
      regex.match(line_with_just_kanji)[:kanji].should == "《"
    end

    it "finds the kanji in a line with kanji kana mix and kana" do
      regex.match(line_with_kanji_kana_mix_and_kana)[:kanji].should == "『る"
    end
  end

  it "parses the kanji" do
    EdictParser.new(line_with_kanji   ).kanji.should == "ˇ"
    EdictParser.new(line_without_kanji).kanji.should == "えっへん"
  end

  it "parses the kana" do
    EdictParser.new(line_with_kanji).kana.should == "なかぐろ"
    EdictParser.new(line_without_kanji).kana.should == "えっへん"
  end

  it "parses the part of speech" do
    parsed = EdictParser.new(line_with_kanji)
    parsed.parts_of_speech.should == {"noun" => ["middle dot (typographical symbol used between parallel terms, names in katakana, etc.)"]}
    parsed.english_definitions.first[0..2].should_not == "(n)"

    parsed = EdictParser.new(line_without_kanji)

    parsed.parts_of_speech.should == {"interjection" => ["ahem"]}
    parsed.english_definitions.first[0..2].should_not == "(int)"
  end

  it "parses the English" do
    EdictParser.new(line_with_kanji).english_definitions.should ==
      ["middle dot (typographical symbol used between parallel terms, names in katakana, etc.)",
       "full-stop mark at mid-character height",
       "interpoint (interword separation)"
    ]
  end


end


