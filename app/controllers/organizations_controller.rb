class OrganizationsController < ApplicationController
  respond_to :html, :json, :xml, :js

  # search results view
  def index
    query = Organization.search(params)
    @orgs = query.content
    @pagination = query.pagination

    # adds top-level category information to orgs for display on results list
    # this will likely be refactored to use the top-level keywords when those 
    # are organized in the data source.
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
    
    @terminology = Organization.terminology(params[:keyword])

    @params = {
      :count => @pagination.items_current,
      :total_count => @pagination.items_total,
      :keyword => params[:keyword],
      :location => params[:location],
      :radius => params[:radius]
    }

     @query_params = {
      :keyword => params[:keyword],
      :location => params[:location],
      :radius => params[:radius]
    }

    respond_to do |format|
      # visit directly
      format.html # index.html.haml

      # visit via ajax
      format.json {
        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/results/body',
           :locals => { :map_present => @map_present }
        end
        render :json => { :content => @html_content , :action => action_name }
      }
    end

  end

  # organization details view
  def show
    # retrieve specific organization's details
    @org = Organization.get(params[:id]).content
    @map_data = generate_map_data(Organization.nearby(params[:id]).content)

    keyword         = params[:keyword] || ''
    location        = params[:location] || ''
    radius          = params[:radius] || ''
    page            = params[:page] || ''

    @search_results_url = '/organizations?keyword='+URI.escape(keyword)+
                          '&location='+URI.escape(location)+
                          '&radius='+radius+
                          '&page='+page

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

  # will be used for mapping nearby locations on details map view
  def generate_map_data(data)

    # generate json for the maps in the view
    # this will be injected into a <script> element in the view
    # and then consumed by the map-manager javascript.
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

    map_data.push({'count'=>map_data.length,'total'=>data.length})
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