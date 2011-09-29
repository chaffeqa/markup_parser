require 'redcarpet'
require "#{File.dirname(__FILE__)}/markdown/string_extensions"
require "#{File.dirname(__FILE__)}/markdown/uv_html_render"
require "#{File.dirname(__FILE__)}/markdown/class_methods"
module MarkupParser
  class Markdown < MarkupParser::Default



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
      @parser = MarkupParser::Markdown.html_parser_with_code_lexer
      self
    end


    private

    # Instantiates the parser for this Markdown instance.
    # Defaults to @@html_parser
    def parser
      @parser ||= MarkupParser::Markdown.html_parser
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