require "markup_parser/version"
require "markup_parser/default"

module MarkupParser

  PARSER_PATH = File.join(File.dirname(__FILE__), 'markup_parser')


  def self.formats
    parser_files.collect {|f| File.basename(f, '.rb') } - ["version"]
  end

  def self.format_parsers
    Hash[*formats.zip(parsers).flatten]
  end

  def self.parsers
    formats.collect {|f|  constantize(camelize("markup_parser/#{f}")) }
  end

  def self.reload_parsers
    parser_files.each { |parser_file| require parser_file }
  end



  private

  def self.parser_files
    Dir.glob( File.join(PARSER_PATH, '*.rb') )
  end

  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

  def self.camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
    if first_letter_in_uppercase
      lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    else
      lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
    end
  end

  def self.humanize(lower_case_and_underscored_word)
    result = lower_case_and_underscored_word.to_s.dup

    inflections.humans.each { |(rule, replacement)| break if result.gsub!(rule, replacement) }
    result.gsub(/_id$/, "").gsub(/_/, " ").capitalize
  end

end

MarkupParser.reload_parsers