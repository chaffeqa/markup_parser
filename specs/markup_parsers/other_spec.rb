require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', 'lib')
require 'markup_parser'

describe "other markup_parsers" do #'specs/markup_parsers/parser_files/README.*'
  Dir[File.join(File.dirname(__FILE__), 'parser_files','README.*')].each do |readme|
    next if readme =~ /html$/
    format = readme.split('/').last.gsub(/^README\./, '')

    define_method "#{format}_spec" do
      source = File.read(readme)

      expected_file = "#{readme}.html"
      expected = File.read(expected_file)
      parser_class = MarkupParser.format_parsers[format]
      actual = parser_class.new(File.read(readme))

      if source != expected
        source.wont_equal actual, "#{format} did not render anything"
      end

      diff = IO.popen("diff -u - #{expected_file}", 'r+') do |f|
        f.write actual
        f.close_write
        f.read
      end

      actual.must_equal expected, <<-message
      #{File.basename expected_file}'s contents don't match command output:
      #{diff}
      message
    end
  end
end
