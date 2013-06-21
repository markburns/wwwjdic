class EdictEntry < HashWithIndifferentAccess
  [:kana, :english_definitions, :english_words].each do |m|
    define_method(m) do
      Array self[m]
    end
  end

  def kanji
    self[:kanji]
  end


  def initialize initial_hash
    super from_json initial_hash
  end

  private

  def from_json input
    input = input.with_indifferent_access
    {}.with_indifferent_access.tap do |e|
      e[:kanji]               = input[:kanji] if input[:kanji]
      e[:kana]                = extract input[:kana]
      e[:english_definitions] = extract input[:english_definitions]
      e[:english_words]       = extract input[:english_words]
    end
  end

  def extract value
    Array(value) if value
  end
end
