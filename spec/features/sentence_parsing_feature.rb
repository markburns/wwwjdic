require './spec/spec_helper'

describe "Sentence parsing", request: true do
  specify do
    sentence = URI.encode "太郎はこの本を二郎を見た女性に渡した。"
    visit "/parse_sentence/#{sentence}"

    expected = <<-EXPECTED_OUTPUT.gsub(/^\s*/, "")
     太郎	名詞,固有名詞,人名,名,*,*,太郎,タロウ,タロー
     は	助詞,係助詞,*,*,*,*,は,ハ,ワ
     この	連体詞,*,*,*,*,*,この,コノ,コノ
     本	名詞,一般,*,*,*,*,本,ホン,ホン
     を	助詞,格助詞,一般,*,*,*,を,ヲ,ヲ
     二	名詞,数,*,*,*,*,二,ニ,ニ
     郎	名詞,一般,*,*,*,*,郎,ロウ,ロー
     を	助詞,格助詞,一般,*,*,*,を,ヲ,ヲ
     見	動詞,自立,*,*,一段,連用形,見る,ミ,ミ
     た	助動詞,*,*,*,特殊・タ,基本形,た,タ,タ
     女性	名詞,一般,*,*,*,*,女性,ジョセイ,ジョセイ
     に	助詞,格助詞,一般,*,*,*,に,ニ,ニ
     渡し	動詞,自立,*,*,五段・サ行,連用形,渡す,ワタシ,ワタシ
     た	助動詞,*,*,*,特殊・タ,基本形,た,タ,タ
     。	記号,句点,*,*,*,*,。,。,。
     EOS
    EXPECTED_OUTPUT

    page.body.should ==   expected
  end
end
