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

    # request is from ajax
    if request.xhr?
      render json: {
        'content' => render_to_string(
          partial: 'component/organizations/results/body'
        )
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

    if @org.coordinates.present?
      @map_url = "http://api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-s("+
        "#{@org.coordinates[0]},#{@org.coordinates[1]})/#{@org.coordinates[0]}"+
        ",#{@org.coordinates[1]},15/400x300.png"
    end

    # request is from ajax
    if request.xhr?
      render json: {
        'content' => render_to_string(
          partial: 'component/organizations/detail/body'
        )
      }
    end
  end
end