require './app/helpers/helpers'

describe Haml::Helpers do
  include Haml::Helpers
  before{@query = 'query'}

  pending "generates a link without any highlighted text" do
    linkable_word('blah').should == "<a href='/word-search?query=blah'><span>blah</span></a>"

    linkable_word('blah query blah').should ==
      "<span>blah<a class='highlight' href='/word-search?query=query'>query</a>blah</span>"

    linkable_word('query').should ==
      "<a class='highlight' href='/word-search?query=query'>query</a>"

    linkable_word('"biological system"').should ==
      "<a href='/word-search?query=\"biological system\"'><span>biological system</span></a>"

  end
end
