class EdictEntry
  ATTRIBUTES = %w(kanji kana english_definitions english_words)
  attr_reader(*ATTRIBUTES)

  def kanji
    @kanji.try(:first) || ""
  end

  def initialize input_hash
    input_hash = input_hash.with_indifferent_access

    @kanji, @kana, @english_definitions, @english_words =
      ATTRIBUTES.map{|a| extract input_hash[a]}
  end

  private

  def extract value
    value = JSON.parse(value) if value
    Array value
  end
end
