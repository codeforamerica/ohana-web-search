class OrganizationsController < ApplicationController
  respond_to :html, :json, :xml, :js

  # search results view
  def index

    perform_search_query(params)

    respond_to do |format|

      # visit directly
      format.html # index.html.haml

      # visit via ajax
      format.json {

        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/results/body', :locals => { :map_present => @map_present }
        end
        render :json => { :content => @html_content , :action => action_name }
      }
    end
    
  end

  # organization details view
  def show
  
    respond_to do |format|

      # visit directly
      # perform search to refresh search results map and return to results button 
      format.html {

        perform_search_query(params)

        @org = @orgs.find { |o| o['_id'] == params[:id] }

        if @org.nil?
          @org = Organization.get(params[:id]).content
        end
      }

      # visit via ajax
      format.json {

        # retrieve specific organization's details
        query = Organization.get(params[:id])
        @org = query.content

        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/detail/body'
        end
        render :json => { :content => @html_content , :action => action_name }
      }
    end

  end

  private

  def perform_search_query(params)
    query = Organization.query(params)
    @orgs = query.content
    @pagination = query.pagination

    @params = {
      :count => @pagination.items_current,
      :total_count => @pagination.items_total,
      :keyword => params[:keyword],
      :location => params[:location],
      :radius => params[:radius]
    }

    keyword         = params[:keyword] || ''
    location        = params[:location] || ''
    radius          = params[:radius] || ''
    page            = @pagination.current.to_s || ''

    search_results_url = '/organizations?keyword='+URI.escape(keyword)+
                          '&location='+URI.escape(location)+
                          '&radius='+radius+
                          '&page='+page

    session['search_results_url'] = search_results_url

    # generate json for the maps in the view
    # this will be injected into a <script> element in the view
    # and then consumed by the map-manager javascript.
    # @map_data parses the @org hash and retrieves all entries
    # that have coordinates, and returns that as json, otherwise @map_data 
    # ends up being nil and can be checked in the view with @map_data.present?
    if @orgs.present?
      @map_data = @orgs.reduce([]) do |result, o| 
        if o.coordinates.present?
          result << {
            'id' => o._id, 
            'name' => o.name, 
            'coordinates' => o.coordinates
          }
        end
        result
      end

      @map_data.push({'count'=>@map_data.length,'total'=>@orgs.length})
      @map_data = @map_data.to_json.html_safe unless @map_data.nil?
    end

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