require './spec/spec_helper'

describe Page do
  context "paginating" do
    it "calculates the entry indexes from page numbers and page size" do
      results = (1..100).to_a
      Page.paginate(results, 1).should == (1..25).to_a
      Page.paginate(results, 2).should == (26..50).to_a
      Page.paginate(results, 2, 10).should == (11..20).to_a
    end
  end
end
