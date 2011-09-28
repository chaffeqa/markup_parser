# -*- encoding: utf-8 -*-
require File.expand_path('../lib/markup_parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Quinn"]
  gem.email         = ["chaffeqa@gmail.com"]
  gem.description   = %q{Standardized markup parsers to use a single format: an object.  Instantiate a specific markup class with text to output formated Html.  Allows for easy code block highlighting using a Proc; defaults to Uv (ruby Ultraviolet)}
  gem.summary       = %q{Standardized markup parsers to a single format.  Sole use is for converting markup text to Html. }
  gem.homepage      = "https://github.com/chaffeqa/markup_parser"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "markup_parser"
  gem.require_paths = ["lib"]
  gem.version       = MarkupParser::VERSION

  gem.add_dependency "uv"
end
