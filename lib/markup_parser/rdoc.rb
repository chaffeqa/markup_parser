require 'rdoc/markup/to_html'

module MarkupParser
  class Rdoc < MarkupParser::Default



    private

    # Returns the fully stylized HTML for this text
    # Forces UTF-8 encoding since Rdoc seems to return ASCII-8BIT
    def parse(text)
      Rdoc.parser.convert(text).force_encoding("UTF-8")
    end

    # Memorized Parser
    def self.parser
      @@parser ||= RDoc::Markup::ToHtml.new
    end

    # Performs my rdoc hotfixes
    def hot_fixes(text)
      text
    end
  end
end
