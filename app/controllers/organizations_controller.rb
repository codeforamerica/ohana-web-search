class OrganizationsController < ApplicationController

	def index
		params[:miles] = 2 if params[:miles].blank?
    
    keyword, @location, radius = params["search-term"], params[:location], params[:miles]

		if Organization.query_invalid?(@location)
			redirect_to root_url, :alert => 'Please enter a full address or a valid 5-digit ZIP code.'
		else
			@organizations, @results_text = Organization.find_by_keyword_and_location(keyword, @location, radius)
		end
		session[:search_results] = request.url
		session[:selected_radius] = params[:miles]
	end

	def show
		@org = Organization.find(params[:id])
		params[:miles] = session[:selected_radius]
		@nearby = @org.nearbys(2)
	end
end