require "spec_helper"

describe "component/organizations/results/_list_view" do
  it_behaves_like "superscript formatting"
end

describe "address formatting" do
  context "when no address elements are present" do
    no_address = JSON.parse(File.read("spec/fixtures/no_address_org.json"))
    it "does not add an address section" do
      assign(:orgs, [stub_model(Hashie::Mash, no_address)])

      render :partial => "component/organizations/results/list_view"
      expect(rendered).to_not match /<p class='address'>/
    end
  end

  context "when all address elements are present" do
    has_address = JSON.parse(File.read("spec/fixtures/organization.json"))
    it "adds an address section" do
      assign(:orgs, [stub_model(Hashie::Mash,
        has_address.merge(:name=>"with address"))])

      render :partial => "component/organizations/results/list_view"
      expect(rendered).to match /<p class='address'>/

      regex = Regexp.new (["<span itemprop\"streetAddress\">2013<sup>th<\/sup> Avenue of the fellows, ",
        "Suite 100<\/span>,\n<span itemprop='addressLocality'>\nSan Maceo, ",
        "\n<\/span>\n<span itemprop='addressRegion'>\nCA\n<\/span>\n",
        "<span itemprop='postalCode'>\n99999\n<\/span>"].join(""))
      expect(rendered).to match regex
    end
  end
end