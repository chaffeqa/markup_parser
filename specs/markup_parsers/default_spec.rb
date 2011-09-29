require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'markup_parser'

describe MarkupParser::Default do

  class MarkupParser::Default
    def hot_fixes(text)
      text + ' hot_fixes'
    end
  end

  describe "initialize" do
    it "accets 1 argument" do
      MarkupParser::Default.new('arg1').must_be_instance_of MarkupParser::Default
      Proc.new {MarkupParser::Default.new('arg1','arg2')}.must_raise ArgumentError
    end
    it "calls hot_fixes" do
      MarkupParser::Default.new('arg1').original_text.must_match "hot_fixes"
    end
  end


  it "successfully outputs text" do
    MarkupParser::Default.new('test text').to_html.must_match /test text/
  end

end