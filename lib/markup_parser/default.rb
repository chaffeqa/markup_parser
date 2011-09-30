require 'nokogiri'

module MarkupParser
  class Default
    attr_reader :original_text, :nokogiri_parser, :html_text, :lexer_proc

    def initialize(text='', &lexer)
      @original_text = hot_fixes(text)
      @lexer_proc = lexer || default_lexer
    end


    # Returns the fully stylized and sanitized HTML
    def to_html
      begin
        nokogiri_parser.to_xhtml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XHTML)
      rescue => e
        puts <<-ERROR
        ******************
        Error in #{self.class}#to_html.
        Reason: #{e.message}.
        Putting error message into the output.
        ******************
        ERROR
        return "<p class='parse_error'>Error in parsing in #{self.class}: #{e.message}.</p>"
      end
    end


    # Instantiates a Nokoguri::HTML fragment parser
    def nokogiri_parser
      begin
        @nokogiri_parser ||= ::Nokogiri::HTML::DocumentFragment.parse(html_text)
      rescue => e
        puts "
        \n******************
        Error in #{self.class}#nokogiri_parser.
        Reason: #{e.message}.
        Putting error message into the output.
        ******************\n"
        @nokogiri_parser = ::Nokogiri::HTML::DocumentFragment.parse("<p class='parse_error'>Error in parsing in #{self.class}: #{e.message}.</p>")
      end
    end

    # Instantiates the html_text via this markup parser
    def html_text
      begin
        @html_text ||= parse(@original_text)
      rescue => e
          puts "
          \n******************
          Error in #{self.class}#html_text.
          Reason: #{e.message}.
          Putting error message into the output.
          ******************\n"
          @html_text = "<p class='parse_error'>Error in parsing in #{self.class}: #{e.message}.</p>"
      end
    end

    # Stylizes the code blocks in the html_text.
    # Uses either a passed in lexer Proc or the default_lexer
    def stylize_code_blocks
        nokogiri_parser.search('pre').each do |node|
          begin
            next unless lang = node['lang']
            text = node.inner_text
            html = @lexer_proc.call(text, lang)
            node.replace(html)
          rescue => e
            puts "
            \n******************
            Error in parsing <pre lang=''> block.
            Reason: #{e.message}.
            Continueing code block parsing.
            ******************\n"
          end
        end
      self
    end




    private

    # Default Lexer Proc
    def default_lexer
      Proc.new {|code, lang| Uv.parse(code, "xhtml", lang, false, "railscasts") }
    end



    ######################################################################
    # TO BE OVERRIDDEN

    # Markup specific Parser invokation
    def parse(text)
      text
    end


    # Performs hotfixes on a per-markup basis
    def hot_fixes(text)
      text
    end

    ######################################################################


  end
end