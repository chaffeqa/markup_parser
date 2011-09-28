module MarkupParser
  class Html < MarkupParser::Default
    puts "\n**************\nMarkupParser::Html loaded\n**************\n"

    private

    # Performs my html hotfixes
    def hot_fixes(text)
      text
    end

  end
end