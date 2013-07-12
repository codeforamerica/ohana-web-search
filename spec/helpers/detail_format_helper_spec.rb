require 'spec_helper'
require 'json'
require 'ohanakapa'

describe DetailFormatHelper do

  before(:each) do
    @org = JSON.parse(File.read("spec/fixtures/organization.json"))
  end

  context '#has_address' do
    
    it 'should be false when no address fields are present' do
      @org["street_address"] = ""
      @org["city"] = ""
      @org["state"] = ""
      @org["zipcode"] = ""
      helper.has_address?(@org).should == false
    end

    it 'should be true when any address fields are present' do
      helper.has_address?(@org).should == true

      @org["street_address"] = ""
      helper.has_address?(@org).should == true
      @org["city"] = ""
      helper.has_address?(@org).should == true
      @org["state"] = ""
      helper.has_address?(@org).should == true
    end

  end

  context '#format_address' do

    it 'should be blank address when no address fields are present' do
      @org["street_address"] = ""
      @org["city"] = ""
      @org["state"] = ""
      @org["zipcode"] = ""
      helper.format_address(@org).should == ""
    end

    it 'formats an address with only a street address' do
      @org["city"] = ""
      @org["state"] = ""
      @org["zipcode"] = ""
      helper.format_address(@org).should == "2013 Avenue of the fellows, Suite 100"
    end

    it 'formats an address with only a city' do
      @org["street_address"] = ""
      @org["state"] = ""
      @org["zipcode"] = ""
      helper.format_address(@org).should == "San Maceo"
    end

    it 'formats an address with only a state' do
      @org["street_address"] = ""
      @org["city"] = ""
      @org["zipcode"] = ""
      helper.format_address(@org).should == "CA"
    end

    it 'formats an address with only a zipcode' do
      @org["street_address"] = ""
      @org["city"] = ""
      @org["state"] = ""
      helper.format_address(@org).should == "99999"
    end

  end

  context '#format_phone' do
    it 'formats an undelimited phone number' do
      helper.format_phone("0000000000").should == "(000) 000-0000"
    end

    it 'formats a dot separated phone number' do
      helper.format_phone("000.000.0000").should == "(000) 000-0000"
    end

    it 'formats a space separated phone number' do
      helper.format_phone("000 000 0000").should == "(000) 000-0000"
    end

    it 'ignores a number that is greater than 10 digits' do
      helper.format_phone("123 456 78900").should == "123 456 78900"
    end

    it 'ignores a number that is less than 10 digits' do
      helper.format_phone("123 456 789").should == "123 456 789"
    end
  end


  require 'spec_helper'

  context '#superscript_ordinals' do

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

end