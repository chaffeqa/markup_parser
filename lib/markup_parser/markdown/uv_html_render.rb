# HTML renderer with Ultraviolet Code Lexer
class UvHtmlRender < Redcarpet::Render::HTML
  puts "\n**************\nUvHtmlRender loaded\n**************\n"
  def block_code(code, language)
    Uv.parse(code, "xhtml", language, false, "railscasts")
  end
end