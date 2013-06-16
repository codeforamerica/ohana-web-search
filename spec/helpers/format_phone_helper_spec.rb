require 'spec_helper'
describe FormatPhoneHelper do

  it 'check for undelimited phone number' do
    expect { format_phone("0000000000").should == "(000) 000-0000" }
  end

  it 'check for dot separated phone number' do
    expect { format_phone("000.000.0000").should == "(000) 000-0000" }
  end

  it 'check for space separated phone number' do
    expect { format_phone("000 000 0000").should == "(000) 000-0000" }
  end

  it 'check for empty phone number' do
    expect { format_phone("")}.to raise_error
  end

  it 'check for numbers that are greater than 10 digits' do
    expect { format_phone("123 456 78900")}.to raise_error
  end

  it 'check for numbers that are less than 10 digits' do
    expect { format_phone("123 456 789")}.to raise_error
  end

end