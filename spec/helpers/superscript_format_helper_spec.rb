require 'spec_helper'

describe SuperscriptFormatHelper do

  it 'check for string beginning with a single "st" ordinal'  do
    superscript_ordinals("1st year").should == "1<sup>st</sup> year"
  end

  it 'check for string beginning with a single "nd" ordinal'  do
    superscript_ordinals("2nd year").should == "2<sup>nd</sup> year"
  end

  it 'check for string beginning with a single "rd" ordinal'  do
    superscript_ordinals("3rd year").should == "3<sup>rd</sup> year"
  end

  it 'check for string beginning with a single "th" ordinal'  do
    superscript_ordinals("4th year").should == "4<sup>th</sup> year"
  end

  it 'check for string containing a single "st", "nd", "rd", "th" ordinal'  do
    superscript_ordinals("1st, 2nd, 3rd, and 4th year").should == "1<sup>st</sup>, 2<sup>nd</sup>, 3<sup>rd</sup>, and 4<sup>th</sup> year"
  end

  it 'check for string containing a "st" as an abbreviation for street'  do
    superscript_ordinals("One St Congregation").should == "One St Congregation"
  end

  it 'check for string containing a "rd" as an abbreviation for road'  do
    superscript_ordinals("3rd Broad Rd").should == "3<sup>rd</sup> Broad Rd"
  end

  it 'check for string containing a two of each of "st", "nd", "rd", "th" ordinal'

=begin
    superscript_ordinals("1st, 2nd, 3rd, and 4th year and beyond into the 21st, 22nd, 23rd, and 24th years").should == "1<sup>st</sup>, 2<sup>nd</sup>, 3<sup>rd</sup>, and 4<sup>th</sup> year and beyond into the 21<sup>st</sup>, 22<sup>nd</sup>, 23<sup>rd</sup>, and 24<sup>th</sup> years"
  end
=end

end