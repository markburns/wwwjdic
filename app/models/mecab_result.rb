class MeCabResult < Array
  def initialize sentence
    parsed = tagger.parse sentence
    rows = parsed.split("\n")[0..-2]

    table = rows.map do|e| 
      row = e.split(",")
      kanji, part_of_speech = row.shift.split " "

      [kanji, part_of_speech] + row
    end


    super table
  end

  def tagger
    @tagger ||= MeCab::Tagger.new
  end
end
