class OrganizationsController < ApplicationController
	respond_to :html, :json, :xml

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
		
		keyword =  params["search_term"]

		if keyword.present?
			@orgs = Organization.query({:keyword=>keyword})
		else
			@orgs = Organization.getAll
		end
		respond_with(@orgs)

	end

	def show
=begin
		@org = Organization.find(params[:id])
		params[:miles] = session[:selected_radius]
		params[:search_term] = session[:search_term]
		params[:location] = session[:location]
		@nearby = @org.nearbys(2)
		respond_with(@org)
=end

		@org = Organization.get(params[:id])
		
		respond_with(@org)

	end
end