module MarkupParser
  class Markdown < MarkupParser::Default
    puts "\n**************\nMarkupParser::Markdown loaded\n**************\n"

    # HTML renderer with Ultraviolet Code Lexer
    class UvHtmlRender < Redcarpet::Render::HTML
      puts "\n**************\nMarkupParser::Markdown::UvHtmlRender loaded\n**************\n"
      def block_code(code, language)
        Uv.parse(code, "xhtml", language, false, "railscasts")
      end
    end


    # Only loads the Markdown parser once
    def self.html_parser_with_code_lexer
      @@html_parser_with_code_lexer ||= Redcarpet::Markdown.new(UvHtmlRender, OPTIONS)
    end


    # Only loads the Markdown parser once
    def self.html_parser
      @@parser_with_code_blocks ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, OPTIONS)
    end

    # Selected Markdown Options
    OPTIONS = {
      autolink: true, #parse links even when they are not enclosed in `<>` characters. Autolinks for the http, https and ftp
                 #protocols will be automatically detected. Email addresses are also handled, and http links without protocol, but
                 #starting with `www.`
      no_intraemphasis: true, #will stop underscores within words from being treated as the start or end of emphasis blocks
                        #and will therefore stop Ruby method or variable names with underscores in them from triggering the emphasis
      lax_html_blocks: true,  #HTML blocks do not require to be surrounded by an empty line as in the Markdown standard.
      strikethrough: true, #parse strikethrough, PHP-Markdown style Two `~` characters mark the start of a strikethrough, e.g. `this is ~~good~~ bad`
      fenced_code_blocks: true, #renders fenced code (```) and (~~~)
      tables: true, #parse tables, PHP-Markdown style
    }







    # Returns the fully stylized HTML for this markdown text
    def html_text
      @html_text ||= parser.render(@original_text)
    end

    # Sets the parser to include as code lexer
    def stylize_code_blocks
      @parser = Markdown.html_parser_with_code_lexer
      self
    end




    private

    # Instantiates the parser for this Markdown instance.
    # Defaults to @@html_parser
    def parser
      @parser ||= Markdown.html_parser
    end

    # Hacks parse to return this instence's parser for a later call
    def parse(text)
      parser
    end

    # Performs my markdown hotfixes
    def hot_fixes(text)
      text.standardize_newlines!
      text.convert_tabs_to_spaces!
      text.correct_gh_code_syntax!
      text
    end

  end
end




# Adds classes to String class...
class String

  # Corrects the gh code block syntax mistake where one would write '~~~ .ruby'
  # and the correct code should be '~~~ruby'
  def correct_gh_code_syntax!
    self.gsub!(/~~~\s\.([a-zA-Z]*)/, '~~~\1')
  end

  # Corrects the ol list elements: which only except the syntax: '1. ...'.
  # Corrected syntaxes: '1)'
  def correct_ol_list_parenth!
    self.gsub!(/(\s*)(\d)\)/,'\1\2.')
  end

  # Converts tabs (\t) to 2 spaces
  def convert_tabs_to_spaces!
    self.gsub!(/\t/, "  ")
  end

  # Standardize line endings
  def standardize_newlines!
    self.gsub!("\r\n", "\n")
    self.gsub!("\r", "\n")
  end

  # Corrects the newlines by stripping the leading whitespace.
  # NOTE: this is a hack to workaround the strange Gollum editor indentation behavior
  def sub_newlines!
    self.gsub!(/([\r\n|\n])[\ ]*(.)/,'\1\2')
  end
end