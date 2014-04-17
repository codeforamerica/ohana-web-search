require 'spec_helper'
# The expected results of these specs are dependent on the per_page
# method in result_summary_helper.rb
describe ResultSummaryHelper do

  describe "when current count < total_count" do

    before(:each) do
      @pages = Hash.new
      @pages[:current_count] = 1
      @pages[:total_count] = 10
      @pages[:current_page] = 1
    end

    context 'when no keyword or location' do
      it 'shows result count only' do
        expect(helper.format_summary({})).
          to eq("Displaying <strong>1-1</strong> of 10 results")
      end
    end

    context 'when keyword but no location' do
      it 'shows result count and keyword' do
        expect(helper.format_summary({ :keyword => 'market' })).
          to eq("Displaying <strong>1-1</strong> of 10 results matching "+
            "<strong>'market'</strong>")
      end
    end

    context 'when location but no keyword' do
      it 'shows result count within 5 miles of location' do
        expect(helper.format_summary({ :location => 'san mateo' })).
          to eq("Displaying <strong>1-1</strong> of 10 results within "+
            "<strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword and location' do
      it 'shows result count, keyword within 5 miles of location' do
        expect(helper.format_summary(
          {
            :keyword => 'market',
            :location => 'san mateo'
          }
        )).
          to eq("Displaying <strong>1-1</strong> of 10 results matching "+
            "<strong>'market'</strong> within <strong>5 miles of "+
            "'san mateo'</strong>")
      end
    end

    context 'with keyword, location and radius' do
      it 'shows result count and keyword within #{radius} miles of location' do
        expect(helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo',
            :radius => 10
          }
        )).
          to eq("Displaying <strong>1-1</strong> of 10 results matching "+
            "<strong>'market'</strong> within <strong>10 miles of "+
            "'san mateo'</strong>")
      end
    end
  end

  describe "when total_count = 1" do

    before(:each) do
      @pages = Hash.new
      @pages[:current_count] = 1
      @pages[:total_count] = 1
      @pages[:current_page] = 1
    end

    context 'when no keyword or location' do
      it 'shows result count only' do
        expect(helper.format_summary({})).
          to eq("Displaying <strong>1 result</strong>")
      end
    end

    context 'when keyword but no location' do
      it 'shows result count and keyword' do
        expect(helper.format_summary({ :keyword => 'market' })).
          to eq("Displaying <strong>1 result</strong> matching "+
            "<strong>'market'</strong>")
      end
    end

    context 'when location but no keyword' do
      it 'shows result count within 5 miles of location' do
        expect(helper.format_summary({ :location => 'san mateo' })).
          to eq("Displaying <strong>1 result</strong> within <strong>5 miles "+
            "of 'san mateo'</strong>")
      end
    end

    context 'with keyword and location' do
      it 'shows result count, keyword within 5 miles of location' do
        expect(helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo'
          }
        )).
          to eq("Displaying <strong>1 result</strong> matching "+
            "<strong>'market'</strong> within <strong>5 miles of 'san mateo'"+
            "</strong>")
      end
    end

    context 'with keyword, location and radius' do
      it 'shows result count and keyword within #{radius} miles of location' do
        expect(helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo',
            :radius => 10
          }
        )).
          to eq("Displaying <strong>1 result</strong> matching "+
            "<strong>'market'</strong> within <strong>10 miles of 'san mateo'"+
            "</strong>")
      end
    end
  end

  describe "when total_count=0" do

    before(:each) do
      @pages = Hash.new
      @pages[:current_count] = 0
      @pages[:total_count] = 0
    end

    context 'when no keyword or location' do
      it 'shows result count only' do
        expect(helper.format_summary({})).to eq("No results")
      end
    end

    context 'when keyword but no location' do
      it 'shows result count and keyword' do
        expect(helper.format_summary({ :keyword => 'market' })).
          to eq("No results matching <strong>'market'</strong>")
      end
    end

    context 'when location but no keyword' do
      it 'shows result count within 5 miles of location' do
        expect(helper.format_summary({ :location => 'san mateo' })).
          to eq("No results within <strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword and location' do
      it 'shows result count, keyword within 5 miles of location' do
        expect(helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo'
          }
        )).
          to eq("No results matching <strong>'market'</strong> within "+
            "<strong>5 miles of 'san mateo'</strong>")
      end
    end

    context 'with keyword, location and radius' do
      it 'shows result count and keyword within #{radius} miles of location' do
        expect(helper.format_summary(
          { :keyword => 'market',
            :location => 'san mateo',
            :radius => 10
          }
        )).
          to eq("No results matching <strong>'market'</strong> within "+
            "<strong>10 miles of 'san mateo'</strong>")
      end
    end
  end
end