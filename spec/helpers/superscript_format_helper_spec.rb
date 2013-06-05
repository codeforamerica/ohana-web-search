require 'spec_helper'
describe SuperscriptFormatHelper do

	it 'check for string beginning with a single "th" ordinal'  do 
		expect { superscript_ordinals("4th year").should == "4<sup>th</sup>" }
	end
	
	it 'check for string containing single "th" ordinal'  do 
		expect { superscript_ordinals("the 25th year").should == "the 25<sup>th</sup> year" }
	end

	it 'check for string containing two "th" ordinal'  do 
		expect { superscript_ordinals("the 25th and 26th year").should == "the 25<sup>th</sup> and 26<sup>th</sup> year" }
	end
	
end