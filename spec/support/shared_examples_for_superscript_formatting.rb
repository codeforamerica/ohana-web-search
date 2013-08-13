shared_examples_for "superscript formatting" do
  attrs = JSON.parse(File.read("spec/fixtures/organization.json"))
  safe_name = "The 1st, 2nd, 3rd, and 4th sons of 25th st & broad rd"
  unsafe_name = "<script>var x = '1st one';alert(x)</script>"

  context "when the string is safe" do
    it "only superscripts the ordinals" do
      assign(:orgs, [
        stub_model(Hashie::Mash, attrs.merge(:name => safe_name))
      ])
      assign(:query_params, {})

      assign(:org,
        stub_model(Hashie::Mash, attrs.merge(:name => safe_name)))

      render
      regex = Regexp.new (["The 1<sup>st<\/sup>, 2<sup>nd<\/sup>, ",
        "3<sup>rd<\/sup>, and 4<sup>th<\/sup> sons of 25<sup>th<\/sup> st ",
        "&amp; broad rd"].join(""))
      expect(rendered).to match regex
    end
  end

  context "when the string is unsafe" do
    it "escapes the script tag" do
      assign(:orgs, [
        stub_model(Hashie::Mash, attrs.merge(:name => unsafe_name))
      ])
      assign(:query_params, {})

      assign(:org,
        stub_model(Hashie::Mash, attrs.merge(:name => unsafe_name)))

      render
      expect(rendered).to_not match /<script>/
    end
  end
end