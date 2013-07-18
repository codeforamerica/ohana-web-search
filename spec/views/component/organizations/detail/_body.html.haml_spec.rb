require "spec_helper"

describe "component/organizations/detail/_body" do
  it_behaves_like "superscript formatting"
end

describe "content exists" do
  
  org = JSON.parse(File.read("spec/fixtures/organization.json"))
  values = Array.new

  org.each do |key, value|
    #stores values and clears them from the source
    values.push value
    org[key] = nil
  end

  it_behaves_like "one field present", org, values
end

describe "address formatting" do
  context "when no address elements are present" do
    no_address = JSON.parse(File.read("spec/fixtures/no_address_org.json"))
    it "does not add an address section" do
      assign(:org, stub_model(Hashie::Mash, no_address))

      render :partial => "component/organizations/detail/body"
      expect(rendered).to_not match /<section class='address'>/
    end
  end

  context "when all address elements are present" do
    has_address = JSON.parse(File.read("spec/fixtures/organization.json"))

    before(:each) do
      assign(:org, stub_model(Hashie::Mash,
        has_address.merge(:name=>"with address")))
      render :partial => "component/organizations/detail/body"
    end

    it "adds an address section" do
      expect(rendered).to match /<section class='address'>/
      expect(rendered).to match /<span class='street-address' itemprop='streetAddress'>/
      expect(rendered).to match /<span class='city' itemprop='addressLocality'>/
      expect(rendered).to match /<span class='state' itemprop='addressRegion'>/
      expect(rendered).to match /<span class='zipcode' itemprop='postalCode'>/
    end

    it "includes a Google Maps directions link to the address" do
      string = 'https:\/\/maps.google.com\/maps\?saddr=current\+location'
      string << '&amp;daddr=2013th Avenue of the fellows, Suite 100,'
      string << ' San Maceo, CA 99999'
      expect(rendered).to match /#{string}/
    end
  end

  context "when only one address element is present" do
    has_address = JSON.parse(File.read("spec/fixtures/street_only_org.json"))
    it "adds an address section" do
      assign(:org, stub_model(Hashie::Mash,
        has_address.merge(:name=>"with address")))

      render :partial => "component/organizations/detail/body"
      expect(rendered).to match /<section class='address'>/
      expect(rendered).to match /<span class='street-address' itemprop='streetAddress'>/
    end
  end
end

describe "phone number formatting" do
  context "when separated by dash" do
    it_behaves_like "phone formatting", [[{ "number" => "703-555-1212" }]]
  end

  context "when all together" do
    it_behaves_like "phone formatting", [[{ "number" => "7035551212" }]]
  end

  context "when separated by dot" do
    it_behaves_like "phone formatting", [[{ "number" => "703.555.1212" }]]
  end

  context "when separated by space" do
    it_behaves_like "phone formatting", [[{ "number" => "703 555 1212" }]]
  end

  context "when less than 10 digits" do
    attrs = JSON.parse(File.read("spec/fixtures/no_address_org.json"))
    phone = [[{ "number" => "703-555-121" }]]

    it "doesn't format the number" do
      assign(:org, stub_model(Hashie::Mash, attrs.merge(:phones => phone)))
      render :partial => "component/organizations/detail/body"
      expect(rendered).to match /class='phones'/
      expect(rendered).to match /703-555-121/
    end
  end

  context "when more than 10 digits" do
    attrs = JSON.parse(File.read("spec/fixtures/no_address_org.json"))
    phone = [[{ "number" => "703-555-12123" }]]

    it "doesn't format the number" do
      assign(:org, stub_model(Hashie::Mash, attrs.merge(:phones => phone)))
      render :partial => "component/organizations/detail/body"
      expect(rendered).to match /class='phones'/
      expect(rendered).to match /703-555-12123/
    end
  end
end