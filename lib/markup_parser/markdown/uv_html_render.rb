# HTML renderer with Ultraviolet Code Lexer
class UvHtmlRender < Redcarpet::Render::HTML
  def block_code(code, language)
    begin
      return Uv.parse(code, "xhtml", language, false, "railscasts")
    rescue => e
      puts "
      \n******************
      Error in parsing <pre lang=''> block.
      Reason: #{e.message}.
      Continueing code block parsing.
      ******************\n"
      return code
    end
  end
end