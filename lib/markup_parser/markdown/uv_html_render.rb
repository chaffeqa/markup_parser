# HTML renderer with Ultraviolet Code Lexer
class UvHtmlRender < Redcarpet::Render::HTML
  def block_code(code, language)
    begin
      return Uv.parse(code, "xhtml", language, false, "railscasts")
    rescue => e
      puts <<-DEBUG
******************
Error in parsing <pre lang='#{language.to_s}'> block.
Reason: #{e.message}.
Continueing code block parsing.
******************
      DEBUG
      return code
    end
  end
end