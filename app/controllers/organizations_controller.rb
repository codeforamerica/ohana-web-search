class OrganizationsController < ApplicationController
  respond_to :html, :json, :xml, :js

  # search results view
  def index

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

    # if no results were returned, set the service terms shown on the no results page
    if @orgs.blank?
      @service_terms = Organization.service_terms
    end

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

    # retrieve specific organization's details
    query = Organization.get(params[:id])
    @org = query.content

    keyword         = params[:keyword] || ''
    location        = params[:location] || ''
    radius          = params[:radius] || ''
    page            = params[:page] || ''

    search_results_url = '/organizations?keyword='+URI.escape(keyword)+
                          '&location='+URI.escape(location)+
                          '&radius='+radius+
                          '&page='+page

    session['search_results_url'] = search_results_url
  
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