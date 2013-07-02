class JapanesePod
  attr_reader :entry

  def initialize entry
    @entry = entry
  end

  def html
    return '' if no_params?

    <<-EOF
    <script type='text/javascript'>
      m('#{uri}');
    </script>
    EOF
  end

  def uri
    @uri ||= 
      if both?
        both_params
      elsif kana?
        kana_param
      elsif kanji?
        kanji_param
      end
  end

  def no_params?
    !kana? && !kanji?
  end

  def both_params
    kana_param << "%26" << kanji_param
  end

  def kana?
    kana_param.present?
  end

  def kanji?
    kanji_param.present?
  end

  def both?
    kana? && kanji?
  end

  def kanji_param
    @kanji_param ||= URI.encode "kanji=#{URI.encode entry.kanji}"      if entry.kanji.present?
  end

  def kana_param
    @kana_param ||= URI.encode "kana=#{URI.encode entry.kana.first }" if entry.kana.any?
  end
end
