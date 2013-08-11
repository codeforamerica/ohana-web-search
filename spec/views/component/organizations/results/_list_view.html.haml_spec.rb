require "spec_helper"

describe "component/organizations/results/_list_view" do
  it_behaves_like "superscript formatting"
end

describe "address formatting" do
  context "when no address elements are present" do
    no_address = JSON.parse(File.read("spec/fixtures/no_address_org.json"))
    it "does not add an address section" do
      assign(:orgs, [stub_model(Hashie::Mash, no_address)])
      assign(:query_params, {})
      render :partial => "component/organizations/results/list_view"
      expect(rendered).to_not match /class='address/
    end
  end

  context "when all address elements are present" do
    has_address = JSON.parse(File.read("spec/fixtures/organization.json"))
    it "adds an address section" do
      assign(:orgs, [stub_model(Hashie::Mash,
        has_address.merge(:name=>"with address"))])
      assign(:query_params, {})
      render :partial => "component/organizations/results/list_view"
      expect(rendered).to match /class='address/
      expect(rendered).to match /<span class=\"street-address\" itemprop=\"streetAddress\">/
      expect(rendered).to match /<span class='city' itemprop='addressLocality'>/
      expect(rendered).to match /<span class='state' itemprop='addressRegion'>/
      expect(rendered).to match /<span class='zipcode' itemprop='postalCode'>/

    end
  end
end