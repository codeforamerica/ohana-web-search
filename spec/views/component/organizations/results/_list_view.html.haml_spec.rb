require "spec_helper"

describe "component/organizations/results/_list_view" do
  it_behaves_like "superscript formatting"
end

describe "address formatting" do
  context "when no address elements are present" do
    no_address = JSON.parse(File.read("spec/fixtures/no_address_org.json"))
    it "does not add an address section" do
      assign(:orgs, [stub_model(Organization, no_address)])

      render :partial => "component/organizations/results/list_view"
      expect(rendered).to_not match /<p class='address'>/
    end
  end

  context "when all address elements are present" do
    has_address = JSON.parse(File.read("spec/fixtures/organization.json"))
    it "adds an address section" do
      assign(:orgs, [stub_model(Organization,
        has_address.merge(:name=>"with address"))])

      render :partial => "component/organizations/results/list_view"
      expect(rendered).to match /<p class='address'>/

      regex = Regexp.new (["2013<sup>th<\/sup> Avenue of the fellows, ",
        "Suite 100, San Maceo, CA 99999"].join(""))
      expect(rendered).to match regex
    end
  end
end