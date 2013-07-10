class OrganizationsController < ApplicationController
	respond_to :html, :json, :xml, :js

	# search results view
	def index
=begin
		params[:miles] = 2 if params[:miles].blank?
    
    keyword, @location, radius = params["search_term"], params[:location], params[:miles]

		if Organization.query_valid?(@location)
			@organizations, @results_text = Organization.find_by_keyword_and_location(keyword, @location, radius)
			session[:search_results] = request.url
			session[:selected_radius] = params[:miles]
			session[:search_term] = params[:search_term]
			session[:location] = params[:location]
			respond_with(@organizations)
		else
			redirect_to root_url, :alert => 'Please enter a full address or a valid 5-digit ZIP code.'
		end
=end
		
		keyword, location, radius, page = params[:keyword], params[:location], params[:radius], params[:page]

		query = Organization.query({:keyword=>keyword,:location=>location,:page=>page,:radius=>radius})
		@orgs = query.content
		@pagination = query.pagination

		@result_summary = ResultSummaryHelper.format_summary({:count=>@pagination.items_current,:total_count=>@pagination.items_total,:keyword=>keyword,:location=>location,:radius=>radius})

		session[:search_results] 	= request.url
		session[:radius] 					= params[:radius]
		session[:keyword] 				= params[:keyword]
		session[:location] 				= params[:location]
		session[:page]						= @pagination.current

		if request.xhr?
			render json: {
					'content' => render_to_string(partial: 'component/organizations/results/body')
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
			@map_url = "http://api.tiles.mapbox.com/v3/examples.map-4l7djmvo/pin-s(#{@org.coordinates[0]},#{@org.coordinates[1]})/#{@org.coordinates[0]},#{@org.coordinates[1]},15/400x300.png"
		end
				
		respond_with(@org)
	end
end