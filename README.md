= Markup Parser

Creating my own rails wiki application forced me to do some research on markup parsers.
I ended up using a ton of Github solutions (and code) but in the end found their 'markup' gem to be a little cumbersome and behind some of the new advances (specifically [Redcarpet 2](https://github.com/tanoku/redcarpet))

So I created my own little library. 

## Goals

* Make the library simple (class oriented, easy to read, small)
* Standardize the parser usage 
* Allow leveraging the features and hooks of parsers

## Usage

List the available markup parsers:

    MarkupParser.format_parsers #=> { 'markdown' => MarkupParser::Markdown, 'rdoc' => MarkupParser::Rdoc }

Parse some text to Html:

    MarkupParser::Markdown.new("body").to_html #=> "<p>body<p>"

**Note** that the `MarkupParser::Markdown` is the parser for Markdown, and can be reused by just creating a new instance.

## Styling Code Blocks

Another goal was to simplify code block styling.  MarkupParser doesn't stylize the code, but instead lets you easily accomplish it with your own code styler:

    markup = MarkupParser::Html.new("<pre lang='ruby'>Class</pre>")
    markup.stylize_code_blocks { |code, lang|
      Albino.colorize(code, lang)
    }
    markup.to_html #=> "<pre class='highlight'><span class='class'>Class</span></pre>"
    
Or:

    MarkupParser::Html.new("<pre lang='ruby'>Class</pre>").stylize_code_blocks { |code, lang|
      Albino.colorize(code, lang)
    }.to_html #=> "<pre class='highlight'><span class='class'>Class</span></pre>"
    
For each code block recognized by the markup language, `stylize_code_blocks` accepts a block with parameters: `code, lang` for you to use.

## Adding Markup Parsers

Ask me (Todo)