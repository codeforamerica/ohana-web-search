require 'google/api_client'

class OrganizationsController < ApplicationController
  before_filter :check_location_id, only: :show

  include ActionView::Helpers::TextHelper
  include ResultSummaryHelper

  # search results view
  def index

    # translate search keyword to current language if other than english
    if params[:keyword].present? && @current_lang != 'en'
      original_word = params[:keyword]
      translated_word = translate(params[:keyword],@current_lang,'en',false)
      params[:keyword] = translated_word[0].translatedText if translated_word.present?
    end

    # initialize query. Content may be blank if no results were found.
    begin
      @orgs = Ohanakapa.search("search", params)
    rescue Ohanakapa::ServiceUnavailable
      redirect_to "#{root_url}",
        alert: "Sorry, we are experiencing issues with search.
          Please try again later." and return
    rescue Ohanakapa::BadRequest => e
      if e.to_s.include?("missing")
        @orgs = Ohanakapa.locations(params)
      else
        @orgs = Ohanakapa.search("search", keyword: "asdfasg")
      end
    end
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

    # The parameters to use to provide a link to the location
    @search_params = request.params.except(:action, :id, :_, :controller)
    @page_params = request.params.include?(:page) ? request.params.except(:page) : request.params

    # Total number of results that have coordinates.
    @total_map_markers = @orgs.map { |org| org.try(:[], :coordinates) }.compact.size

    @array_for_maps = @orgs.map do |org|
      {
        latitude: org.try(:[], :latitude),
        longitude: org.try(:[], :longitude),
        name: org.name,
        org_name: org.organization.name,
        slug: org.slug
      }
    end

    # construct html and plain results summaries for use in display in the view (html)
    # and for display in the page title (plain)
    @map_search_summary_html = format_map_summary
    @search_summary_html = format_summary(params)
    @search_summary_plain = @search_summary_html.gsub('<strong>', '').gsub('</strong>', '')

    expires_in 30.minutes, :public => true
    if stale?(etag: @orgs, public: true)
      respond_to do |format|
        format.html # index.html.haml
      end
    end
  end

  # organization details view
  def show
    # retrieve specific organization's details
    id = params[:id].split("/")[-1]
    @org = Organization.get(id)

    initialize_filter_data(@org) # intialize search filter data

    # The parameters to use to provide a link back to search results
    @search_params = request.params.except(:action, :id, :_, :controller)

    if @org.key?(:services)
      @aggregate_categories = []
      @org.services.each do |service|
        if service.key?(:categories) && service.categories.length > 0
          service.categories.each do |category|
            @aggregate_categories.push(category)
          end
        end
      end
    end

    # To disable or remove the Result list button on details page
    # when visiting location directly
    #@referer = request.env['HTTP_REFERER']

    # respond to direct and ajax requests
    expires_in 30.minutes, :public => true
    if stale?(etag: @org, public: true)
      respond_to do |format|
        format.html #show.html.haml
      end
    end

  end

  private

  # Used for passing rendered HTML partials in a json response to requests made via ajax
  # from http://stackoverflow.com/questions/4810584/rails-3-how-to-render-a-partial-as-a-json-response
  # execute a block with a different format (ex: an html partial while in an ajax request)
  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
  end

  # If the location id is invalid, redirect to home page
  # and display an alert (TODO), or do something else.
  def check_location_id
    id = params[:id].split("/")[-1]
    redirect_to root_path unless Organization.get(id)
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