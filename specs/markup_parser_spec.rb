require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'markup_parser'

describe MarkupParser do
  before do
    create_test_markup_parser
    MarkupParser.reload_parsers
  end
  after do
    tear_down_test_markup_parser
  end

  describe "PARSER_PATH" do
    it "is a string" do
      MarkupParser::PARSER_PATH.must_be_instance_of String
    end
  end

  describe "formats" do
    it "returns all formats" do
      MarkupParser.formats.must_be_instance_of Array
      MarkupParser.formats.must_include "test_markup"
    end
    it "wont include 'version'" do
      MarkupParser.formats.wont_include "version"
    end
  end

  describe "parsers" do
    it "returns all formats" do
      MarkupParser.parsers.must_be_instance_of Array
      MarkupParser.parsers.must_include MarkupParser::TestMarkup
    end
  end

  describe "format_parsers" do
    it "returns a hash with format {'format': Class}" do
      MarkupParser.format_parsers.must_be_instance_of Hash
      MarkupParser.format_parsers['test_markup'].must_equal MarkupParser::TestMarkup
    end
  end
end


def create_test_markup_parser
  test_markup_contents = <<-CONTENT
    module MarkupParser
      class TestMarkup < MarkupParser::Default


        private

        # Markup specific Parser invokation
        def parse(text)
          text + " was parsed"
        end

        # Performs my html hotfixes
        def hot_fixes(text)
          text = text + " was hotfixed"
        end

      end
    end
  CONTENT
  output = %x[
    cd #{MarkupParser::PARSER_PATH}
    touch test_markup.rb
    echo \'#{test_markup_contents}\' > test_markup.rb
    ]
    #puts output
end

def tear_down_test_markup_parser
  output = %x[
    cd #{MarkupParser::PARSER_PATH}
    rm test_markup.rb
    ]
  #puts output
end