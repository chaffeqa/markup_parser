require "markup_parser/version"

module MarkupParser
  puts "\n**************\nMarkupParser loaded\n**************\n"

  self.parser_path = File.join(File.dirname(__FILE__), 'markup_parser')

  def self.parsers
    @parsers ||= Dir.glob( File.join(@parser_path, '*.rb') ).collect {|f| File.basename(f, '.rb') } - ["default"]
  end
end
