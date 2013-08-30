class OrganizationsController < ApplicationController
  respond_to :html, :json, :xml, :js

  # search results view
  def index

    # initialize terminology box if the keyword is a term 
    # that has a matching partial as defined in Organization.terminology
    # and app/views/component/terminology
    @terminology = Organization.terminology(params[:keyword])

    # initialize query. Content may be blank if no results were found.
    query = Organization.search(params)
    
    # check for results against keyword mapping if content is blank.
    if query.content.blank?
      query = Organization.keyword_mapping(query, params)
    end

    # Initialize @orgs and @pagination properties that are used in the views
    @orgs = query.content
    @pagination = query.pagination

    # Adds top-level category terms to @orgs for display on results list.
    # This will likely be refactored to use the top-level keywords when those 
    # are organized in the database using OE or equivalent.
    if @orgs.present?
      top_level_service_terms = []
      Organization.service_terms.each do |term|
        top_level_service_terms.push(term[:name]);
      end

      @orgs.each do |org|
        org.category = []
        if org.keywords.present?
          org.keywords.each do |keyword|
            org.category.push( keyword ) if top_level_service_terms.include? keyword.downcase
          end
          org.category = org.category.uniq
          org.category = org.category.sort
        end
      end
    end

    # Used in the format_summary method in the result_summary_helper
    @params = {
      :count => @pagination.items_current,
      :total_count => @pagination.items_total,
      :keyword => params[:keyword],
      :location => params[:location],
      :radius => params[:radius]
    }

    # Used for appending query parameters to result entry link in list_view
    # so that the search field retains its state when visiting a detail page.
    @query_params = {
      :keyword => params[:keyword],
      :location => params[:location],
      :page => params[:page],
      :radius => params[:radius]
    }


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
    @org = Organization.get(params[:id]).content

    # initializes map data
    @map_data = generate_map_data(Organization.nearby(params[:id]).content)
    
    # set up the search results URL
    keyword         = params[:keyword] || ''
    location        = params[:location] || ''
    radius          = params[:radius] || ''
    page            = params[:page] || ''

    @search_results_url = '/organizations?page='+page
    @search_results_url += '&keyword='+URI.escape(keyword) if keyword.present?
    @search_results_url += '&location='+URI.escape(location) if location.present?
    @search_results_url += '&radius='+radius if radius.present?
    @search_results_url += '#'+params[:id]

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
      if o.coordinates.present?
        result << {
          'id' => o._id, 
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
end