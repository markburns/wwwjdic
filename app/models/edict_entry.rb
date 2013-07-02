class EdictEntry
  ATTRIBUTES = %w(kanji kana english_definitions english_words).map(&:to_sym)
  attr_reader(*ATTRIBUTES)

  def kanji
    @kanji.try(:first) || ""
  end

  def initialize input_hash
    @kanji, @kana, @english_definitions, @english_words =
      ATTRIBUTES.map{|a| extract input_hash[a]}
  end

  private

  def extract value
    JSON.parse value if value
  end
end
