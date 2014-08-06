require 'google/api_client'

class OrganizationsController < ApplicationController
  def index

    # translate search keyword to current language if other than english
    if params[:keyword].present? && @current_lang != 'en'
      original_word = params[:keyword]
      translated_word = translate(params[:keyword],@current_lang,'en',false)
      params[:keyword] = translated_word[0].translatedText if translated_word.present?
    end

    @orgs = Organization.search(params)

    params[:keyword] = original_word if original_word.present?

    initialize_filter_data(@orgs) # intialize search filter data

    headers = Ohanakapa.last_response.headers

    @pages = Hash.new

    @pages[:total_count]   = headers["X-Total-Count"].to_i
    @pages[:current_count] = @orgs.blank? ? 0 : @orgs.count

    @pages[:total_pages]   = headers["X-Total-Pages"].to_i
    @pages[:current_page]  = headers["X-Current-Page"].to_i
    @pages[:prev_page]  = headers["X-Previous-Page"].to_i
    @pages[:next_page]  = headers["X-Next-Page"].to_i

    @pages[:prev_page] = nil if @pages[:prev_page] == 0
    @pages[:next_page] = nil if @pages[:next_page] == 0

    @pages[:pages] = []

    min = @pages[:current_page].to_i-2
    max = @pages[:current_page].to_i+2
    while min < 1
      min = min+1
      max = max+1
    end
    while max > @pages[:total_pages]
      min = min-1 if min > 1
      max = max-1
    end

    min.upto(max) do |n|
      @pages[:pages].push(n)
    end

    @page_params = request.params.include?(:page) ? request.params.except(:page) : request.params

    # initializes map data for search results map
    @map_data = generate_map_data(@orgs)
  end

  # organization details view
  def show
    id = params[:id].split('/')[-1]
    @org = Organization.get(id)

    initialize_filter_data(@org) # intialize search filter data

    if @org.key?(:services)
      @categories = @org.services.map { |s| s[:categories] }.flatten.compact.uniq
    end
  end

  private

  # Used for generating data for the two Google maps used in the app:
  # The search results map and the map on the details view.
  # Method generates json for the maps that will be injected into a <script>
  # element in the view and then consumed by the map-manager or detail-map-manager
  # javascript. The map_data variable parses the object returned from the API
  # and retrieves all entries that have coordinates, and returns that as json,
  # otherwise map_data ends up being nil and can be checked in the view with
  # map_data.present?
  # @param data [Object] API response data
  # @return [Object] JSON object containing id, name, and coordinates.
  # Or nil if there are no mappable entries.
  def generate_map_data(data)

    return nil if data.blank? # return immediately if data is empty

    @total_map_count = data.count # total number of returned results
    @current_map_count = 0

    coords_list = Hash.new(0) # used for tracking coordinate frequencies

    map_data = data.reduce([]) do |result, o|

      # Uncomment this section if it is desirable to hide the
      # "San Maceo" test case from results list (521d33a01974fcdb2b0026a9)
      #if o.name == "San Maceo Agency"
      #  data.delete(o)
      #else

      if o[:coordinates].present?
        new_coords = o.coordinates

        # increment coordinate tracking and offset position if greater than 1 occurrance
        coords_list[new_coords.to_s] += 1
        offset = (0.0001*(coords_list[new_coords.to_s]-1))
        new_coords = [o.coordinates[0]-offset,o.coordinates[1]]

        kind = o.kind if o.key?(:kind)

        details = {
          'id' => o.id,
          'name' => o.name,
          'kind' => kind,
          'coordinates' => new_coords
        }

        if o.organization.key?(:name) && o.organization.name != o.name
          details['agency'] = o.organization.name;
        end

        result << details
        @current_map_count = @current_map_count+1
      end

      result
    end

    # set a count and total value that will show how many (count)
    # of the data (total) were able to be located because they had coordinates.
    map_data.push({'count'=>@current_map_count,'total'=>@total_map_count})

    # set map_data to nil if there are no entries
    map_data = nil if (map_data[0]['count'] == 0)
    map_data = map_data.to_json.html_safe unless map_data.nil?
  end

  # Cache filter values.
  # @param collection [Object]
  # @param key [String] The key name in the cache for the aggregated values.
  # @param block [Block] block to call for accessing a particular caller value.
  # @return [Array] The aggregated values.
  def cache_filter_values(collection, key, &block)
    aggregate = session[key] || []

    if collection.respond_to?('each')
      collection.each { |org|
        val = block.call(org)
        aggregate.pop if aggregate.length >= 5 && aggregate.include?(val) == false
        aggregate.unshift( val ) if val.present?
        break if aggregate.length >= 5
      }
      aggregate.uniq!
      session[key] = aggregate
    end

    aggregate
  end

  def initialize_filter_data(collection)
    # cached locations
    @aggregate_locations = cache_filter_values(collection,'aggregate_locations'){|org|
      if org.key?(:address)
        val = org.address['city']
        val += ", #{org.address['state']}" if org.address['state'].present?
      end
    }

    # cached organization names
    @aggregate_org_names = cache_filter_values(collection,'aggregate_org_names'){|org|
      org.organization.name if org.key?(:organization) && org.organization.name != org.name
    }
  end

  # Translate the page using the Google Translate API.
  # @param [String] text to translate
  # @param [String] target language code to translate into
  def translate(text, source, target, is_html)

    client = Google::APIClient.new(:key => ENV['GOOGLE_TRANSLATE_API_TOKEN'], :authorization => nil)
    translate = client.discovered_api('translate', 'v2')
    html_or_plain = is_html ? "html" : "text"

    params = {
        'format' => html_or_plain,
        'source' => source,
        'target' => target,
        'q' => text
      }

    result = client.execute(
      :api_method => translate.translations.list,
      :parameters => params
    )
    result.data.translations
  end

end