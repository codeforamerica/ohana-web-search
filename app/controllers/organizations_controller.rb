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

    session[:search_results]  = request.url
    session[:radius]          = params[:radius]
    session[:keyword]         = params[:keyword]
    session[:location]        = params[:location]
    session[:page]            = @pagination.current


    respond_to do |format|
      format.html # index.html.haml
      format.json {

        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/results/body'
        end
        render :json => { :content => @html_content }
      }
    end
    
  end

  # organization details view
  def show
    params[:radius] = session[:radius]
    params[:keyword] = session[:keyword]
    params[:location] = session[:location]

    query = Organization.get(params[:id])
    @org = query.content

    respond_to do |format|
      format.html # index.html.haml
      format.json {

        with_format :html do
          @html_content = render_to_string partial: 'component/organizations/detail/body'
        end
        render :json => { :content => @html_content }
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