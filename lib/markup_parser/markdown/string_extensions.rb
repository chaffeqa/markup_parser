# Adds classes to String class...
class String

  # Corrects the gh code block syntax mistake where one would write '~~~ .ruby'
  # and the correct code should be '~~~ruby'
  def correct_gh_code_syntax!
    self.gsub!(/~~~\s\.([a-zA-Z]*)/, '~~~\1')
  end

  # Corrects the ol list elements: which only except the syntax: '1. ...'.
  # Corrected syntaxes: '1)'
  def correct_ol_list_parenth!
    self.gsub!(/(\s*)(\d)\)/,'\1\2.')
  end

  # Converts tabs (\t) to 2 spaces
  def convert_tabs_to_spaces!
    self.gsub!(/\t/, "  ")
  end

  # Standardize line endings
  def standardize_newlines!
    self.gsub!("\r\n", "\n")
    self.gsub!("\r", "\n")
  end

  # Corrects the newlines by stripping the leading whitespace.
  # NOTE: this is a hack to workaround the strange Gollum editor indentation behavior
  def sub_newlines!
    self.gsub!(/([\r\n|\n])[\ ]*(.)/,'\1\2')
  end
end