shared_examples "one field present" do |org,values|
  org.each_with_index do |key,index|
    ignoreFields = ["_id","leaders","distance","created_at","coordinates","keywords","service_wait","funding_sources"]
    it "only has #{key[0]}" do
      if ignoreFields.include? key[0]
        puts "#{key[0]} skipped, as it is not used in the view"
      else
        assign(:org, stub_model(Hashie::Mash,
          org.merge(key[0]=>values[index])))
        render :partial => "component/organizations/detail/body"

        # check for CSS class name
        css_class = css_class_format(key[0])
        expect(rendered).to match /class='#{css_class}/

        # check for html content, and handle any special field formatting cases
        check_value = values[index]
        
        if key[0] == "updated_at"
          expect(rendered).to match /#{Regexp.escape(format_timestamp(check_value))}/

        elsif key[0] == "street_address"
          expect(rendered).to match /#{Regexp.escape(superscript_ordinals(check_value))}/

        elsif key[0] == "phones"
          check_value.each do |item|
            item.each do |subitem|
              expect(rendered).to match /#{Regexp.escape(format_phone(subitem['number']))}/
              expect(rendered).to match /#{Regexp.escape(subitem['phone_hours'])}/
              expect(rendered).to match /#{Regexp.escape(subitem['department'])}/
            end
          end

        elsif key[0] == "ttys" || key[0] == "faxes"
          check_value.each do |item|
              expect(rendered).to match /#{Regexp.escape(format_phone(item))}/
          end

        elsif key[0] == "market_match"
          expect(rendered).to match /Market Match/
          
        elsif check_value.kind_of?(Array)
          check_value.each do |item|
              expect(rendered).to match /#{Regexp.escape(item)}/
          end
        
        else
          expect(rendered).to match /#{Regexp.escape(check_value)}/
        end
      end
    end
  end
end