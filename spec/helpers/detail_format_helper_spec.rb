require 'spec_helper'
require 'json'

describe DetailFormatHelper do

  before(:each) do
    @empty = Hash.new
    @org = JSON.parse("{\"_id\":\"51d5b18ca4a4d8b01b3e43d3\",\"accessibility_options\":[\"Wheelchair accessible\"],\"agency\":null,\"ask_for\":\"Jacquie Klose (Administrator)\",\"city\":null,\"coordinates\":[-122.4325682,37.860909],\"created_at\":\"2013-07-04T03:54:41Z\",\"description\":\"Supports the preservation and interpretation of history, structures and natural resources of Angel Island State Park. The association works in partnership with the California State Parks to raise funds, educate and volunteer to provide an enjoyable experience for the visitor.\",\"eligibility_requirements\":\"None\",\"emails\":[\"aia@angelisland.org\"],\"faxes\":[\"415 435-2950\"],\"fees\":null,\"funding_sources\":[\"Donations\",\"Fundraising\",\"Grants\"],\"how_to_apply\":null,\"keywords\":null,\"languages_spoken\":null,\"leaders\":null,\"market_match\":null,\"name\":\"Angel Island Association\",\"payments_accepted\":null,\"phones\":[[{\"number\":\"415 435-3972\",\"phone_hours\":\"(Monday-Friday, 9-3)\"}]],\"products_sold\":null,\"service_area\":[\"Alameda County\",\"Contra Costa County\",\"Marin County\",\"San Francisco County\",\"San Mateo County\",\"Santa Clara County\",\"worldwide\"],\"service_areas\":null,\"service_hours\":\"Daily, sunrise to sunset\",\"service_wait\":null,\"services_provided\":\"Supports the preservation and interpretation of history, structures and natural resources of Angel Island State Park.\",\"state\":null,\"street_address\":\"Angel Island State Park\",\"target_group\":null,\"transportation_availability\":null,\"ttys\":null,\"updated_at\":\"2013-07-04T04:32:43Z\",\"urls\":[\"http://angelisland.org\"],\"zipcode\":null}")
  end  

  context '#has_address' do
    
    it 'should be false when no address fields are present' do
      expect { has_address(@empty).should == false }
    end

    it 'should be true when address fields are present' do
      expect { has_address(@org).should == true }
      @empty["street_address"] = @org["street_address"]
      expect { has_address(@empty).should == true }
      @empty["city"]  = @org["city"]
      expect { has_address(@empty).should == true }
      @empty["state"]  = @org["state"]
      expect { has_address(@empty).should == true }
      @empty["zipcode"]  = @org["zipcode"]
      expect { has_address(@empty).should == true }
    end

  end

  context '#format_address' do

  end

  context '#format_phone' do
    it 'should be formatted for undelimited phone number' do
      expect { format_phone("0000000000").should == "(000) 000-0000" }
    end

    it 'should be formatted for a dot separated phone number' do
      expect { format_phone("000.000.0000").should == "(000) 000-0000" }
    end

    it 'should be formatted for a space separated phone number' do
      expect { format_phone("000 000 0000").should == "(000) 000-0000" }
    end

    it 'should be unformatted for a empty phone number' do
      expect { format_phone("").should "" }
    end

    it 'should be unformatted for numbers that are greater than 10 digits' do
      expect { format_phone("123 456 78900").should == "123 456 78900" }
    end

    it 'should be unformatted for numbers that are less than 10 digits' do
      expect { format_phone("123 456 789").should == "123 456 789" }
    end
  end

end