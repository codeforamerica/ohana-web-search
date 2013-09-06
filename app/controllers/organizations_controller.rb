class OrganizationsController < ApplicationController
  respond_to :html, :json, :xml, :js

  before_filter :check_location_id, only: :show

  TOP_LEVEL_CATEGORIES = %w(care education emergency food goods health housing
    legal money transit work).freeze

  # search results view
  def index

    # initialize terminology box if the keyword is a term
    # that has a matching partial as defined in Organization.terminology
    # and app/views/component/terminology
    @terminology = Organization.terminology(params[:keyword])

    # initialize query. Content may be blank if no results were found.
    @orgs = Organization.search(params)

    ## check for results against keyword mapping if content is blank.
    # if @orgs.blank?
    #   @orgs = Organization.keyword_mapping(params)
    # end

    headers = Ohanakapa.last_response.headers

    @prev_page     = headers["X-Previous-Page"]
    @next_page     = headers["X-Next-Page"]
    @current_page  = headers["X-Current-Page"]
    @total_pages   = headers["X-Total-Pages"]
    @total_count   = headers["X-Total-Count"]
    @current_count = @orgs.blank? ? 0 : @orgs.count

    # The parameters to use to provide a link to the location
    @search_params = request.params.except(:action, :id, :_, :controller)

    ## Adds top-level category terms to @orgs for display on results list.
    ## This will likely be refactored to use the top-level keywords when those
    ## are organized in the database using OE or equivalent.
    # if @orgs.present?
    #   @orgs.each do |org|
    #     org.category = []
    #     if org.keywords.present?
    #       org.keywords.each do |k|
    #         org.category.push(k) if TOP_LEVEL_CATEGORIES.include? k.downcase
    #       end
    #     end
    #     org.category = org.category.uniq.sort
    #   end
    # end

    # initializes map data
    @map_data = generate_map_data(@orgs)

    # respond to direct and ajax requests
    respond_to do |format|
      # visit directly
      format.html # index.html.haml

      # visit via ajax
      format.json {
        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/results/body'
        end
        render :json => { :content => @html_content , :action => action_name }
      }
    end

  end

  # organization details view
  def show
    # retrieve specific organization's details
    @org = Organization.get(params[:id])

    # initializes map data
    @map_data = generate_map_data(Ohanakapa.nearby(params[:id]))

    # The parameters to use to provide a link back to search results
    @search_params = request.params.except(:action, :id, :_, :controller)
    # To disable or remove the Result list button on details page
    # when visiting location directly
    @referer = request.env['HTTP_REFERER']

    # respond to direct and ajax requests
    respond_to do |format|
      # visit directly
      format.html #show.html.haml

      # visit via ajax
      format.json {

        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/detail/body'
        end
        render :json => { :content => @html_content , :action => action_name }
      }
    end

  end

  private

  # Used for mapping nearby locations on details map view
  # @param data [Object] nearby API response
  # @return [Object] JSON object containing id, name, and coordinates.
  # Or nil if there are no nearby map entries.
  def generate_map_data(data)

    # generate json for the maps in the view
    # this will be injected into a <script> element in the view
    # and then consumed by the detail-map-manager javascript.
    # map_data parses the @org hash and retrieves all entries
    # that have coordinates, and returns that as json, otherwise map_data
    # ends up being nil and can be checked in the view with map_data.present?
    map_data = data.reduce([]) do |result, o|
      if o.key?(:coordinates)
        result << {
          'id' => o.id,
          'name' => o.name,
          'coordinates' => o.coordinates
        }
      end
      result
    end

    # set a count and total value that will show how many (count)
    # of the data (total) were able to be located because they had coordinates.
    map_data.push({'count'=>map_data.length,'total'=>data.length})

    # set map_data to nil if there are no entries
    map_data = nil if (map_data.count == 0)
    map_data = map_data.to_json.html_safe unless map_data.nil?
  end

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
    redirect_to root_path unless Organization.get(params[:id])
  end
end