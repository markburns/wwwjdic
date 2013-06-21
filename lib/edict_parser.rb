#encoding: utf-8
require 'active_support/core_ext/object'
require './lib/edict_constants'

class ::Regexp
  def +(re)
    Regexp.new self.to_s + re.to_s
  end
end

class EdictParser
  include EdictConstants
  attr_accessor :line

  PART_OF_SPEECH                = /^\(([^\)]+)\) ?/
  ENGLISH_WORD_ALLOWING_HYPHENS = /[a-z]+-?[a-z]*/i
  MEANING_SEPARATOR             = "/"

  KANJI                         = /(?<kanji>[\p{Graph}]+)\s/xu
  KANA                          = /(?<kana>[\p{Katakana}|\p{Hiragana}]+)/xu
  KANJI_THEN_KANA               = KANJI + /\[/u + KANA + /\]/u


  def initialize line
    self.line = line

    valid?
  end

  def line= line
    @line = line
    @kanji, @kana = nil, nil
  end

  def line
    @line[0..-2]
  end

  def valid?
    (kanji.present? || kana.present?) && english_definitions.present?
  end

  def kanji
    @kanji ||= KANJI.match(line).try(:"[]",:kanji)
  end

  def kana
    @kana ||=  kanji_then_kana || just_kana
  end

  def just_kana
    KANA.match(line).try(:"[]",:kana)
  end

  def kanji_then_kana
    KANJI_THEN_KANA.match(line).try(:"[]",:kana)
  end


  def english_definitions
    @english_definitions ||= english_with_pos.map do |d|
      d.gsub PART_OF_SPEECH, ""
    end
  end

  def english_words
    @english_words ||= english_definitions.map do |words_with_punctuation|
      words_with_punctuation.scan ENGLISH_WORD_ALLOWING_HYPHENS
    end.flatten.uniq
  end

  def parts_of_speech
    @parts_of_speech ||= parse_parts_of_speech
  end
  private

  def english_with_pos
    @english_with_pos ||= line.split(MEANING_SEPARATOR)[1..-1]
  end

  def parse_parts_of_speech
    pos = {}
    english_with_pos.each do |definition|
      if definition =~ PART_OF_SPEECH
        pos[POS_ABBREVIATIONS[$1]] ||= []
        pos[POS_ABBREVIATIONS[$1]] << definition.gsub(PART_OF_SPEECH, "")
      end
    end
    pos
  end
end
