module MarkupParser
  class Default
    puts "\n**************\nMarkupParser::Default loaded\n**************\n"
    attr_reader :original_text, :nokoguri_parser, :html_text, :lexer_proc

    def initialize(text='', &lexer)
      @original_text = hot_fixes(text)
      @lexer_proc = lexer || default_lexer
    end


    # Returns the fully stylized and sanitized HTML
    def to_html
      begin
        nokoguri_parser.to_xhtml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XHTML)
      rescue => e
        puts "
        \n******************
        Error in #{self.class}#to_html.
        Reason: #{e.message}.
        Putting error message into the output.
        ******************\n"
        return "<p class='parse_error'>Error in parsing in #{self.class}: #{e.message}.</p>"
      end
    end


    # Instantiates a Nokoguri::HTML fragment parser
    def nokoguri_parser
      begin
        @nokoguri_parser ||= Nokogiri::HTML::DocumentFragment.parse(html_text)
      rescue => e
        puts "
        \n******************
        Error in #{self.class}#nokoguri_parser.
        Reason: #{e.message}.
        Putting error message into the output.
        ******************\n"
        @nokoguri_parser = Nokogiri::HTML::DocumentFragment.parse("<p class='parse_error'>Error in parsing in #{self.class}: #{e.message}.</p>")
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
        nokoguri_parser.search('pre').each do |node|
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