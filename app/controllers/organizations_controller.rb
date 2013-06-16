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
		
		keyword, location, radius, page = params["search_term"], params[:location], params[:miles], params[:page]

		query = Organization.query({:keyword=>keyword,:location=>location,:page=>page})
		@orgs = query.content
		@pagination = query.pagination
		@result_summary = ResultSummaryHelper.format_summary({:count=>@pagination.items_current,:total_count=>@pagination.items_total,:keyword=>keyword,:location=>location,:radius=>radius})

		session[:search_results] = request.url
		session[:selected_radius] = params[:miles]
		session[:search_term] = params[:search_term]
		session[:location] = params[:location]

		if request.xhr?
			render json: {
					'results_header' => render_to_string(partial: 'ajax/organizations/results_header'),
			    'results_list' => render_to_string(partial: 'ajax/organizations/results_list')
			}

		end
		
	end

	# organization details view
	def show
=begin
		@org = Organization.find(params[:id])
		params[:miles] = session[:selected_radius]
		params[:search_term] = session[:search_term]
		params[:location] = session[:location]
		@nearby = @org.nearbys(2)
		respond_with(@org)
=end

		query = Organization.get(params[:id])
		@org = query.content
		
		respond_with(@org)

	end

end