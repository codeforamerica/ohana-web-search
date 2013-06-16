module SuperscriptFormatHelper

  # Adds <sup>XX</sup> around ordinals in string
  def superscript_ordinals(string)
    val = parse(string,'st')
    val = parse(val,'nd')
    val = parse(val,'rd')
    val = parse(val,'th')
    val.html_safe
  end

  private
  def parse(string, ordinal)
    exp = '(^.*\d)('+ordinal+')(\b.*)'
    regex = Regexp.new exp
    fname = string.split(regex)

    parsed = ''
    fname.each do |snippet|

      if snippet == ordinal
        snippet = '<sup>'+ordinal+'</sup>'
      end

      parsed += snippet

    end

    parsed
  end

end