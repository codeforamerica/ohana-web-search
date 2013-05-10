class OrganizationsController < ApplicationController

	def index
		params[:miles] = 2 if params[:miles].blank?
    
    keyword, location, radius = params["search-term"], params[:location], params[:miles]

		if Organization.query_invalid?(location)
			redirect_to root_url, :alert => 'Please enter a full address or a valid 5-digit ZIP code.'
		else
			@locations, @results_text = Organization.find_by_keyword_and_location(keyword, location, radius)
		end
	end

	def show
		@org = Organization.find(params[:id])
		@nearby = @org.nearbys(2)
	end
end