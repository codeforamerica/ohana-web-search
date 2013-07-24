shared_examples_for "phone formatting" do |phone|
  attrs = JSON.parse(File.read("spec/fixtures/no_address_org.json"))

  it "properly formats the phone number" do
    assign(:org, stub_model(Hashie::Mash, attrs.merge(:phones => phone)))
    render :partial => "component/organizations/detail/body"
    expect(rendered).to match /<span itemprop='telephone'>/
    expect(rendered).to match /\(703\) 555-1212/
  end
end