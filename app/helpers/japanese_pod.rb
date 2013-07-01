class JapanesePod
  attr_reader :entry

  def initialize entry
    @entry = entry
  end

  def html
    return '' unless uri

    <<-EOF
    <script type='text/javascript'>
      m('#{uri}');
    </script>
    EOF
  end

  def uri
    @uri ||= 
      if kana_encoded.present? && kanji_encoded.present?
        kana_encoded << "%26" << kanji_encoded
      elsif kana_encoded.present?
        kana_encoded
      elsif kanji_encoded.present?
        kanji_encoded
      end
  end

  def kanji_encoded 
    @kanji_encoded ||= URI.encode "kanji=#{URI.encode entry.kanji}"      if entry.kanji.present?
  end

  def kana_encoded
    @kana_encoded ||= URI.encode "kana=#{URI.encode entry.kana.first }" if entry.kana.any?
  end
end
