class OrganizationsController < ApplicationController

	def index
		params[:miles] = 5 if params[:miles].blank?
    
    keyword, address, radius = params[:keyword_search], params[:address_search], params[:miles]

		if Organization.query_invalid?(address)
			redirect_to root_url, :alert => 'Please enter a full address or a valid 5-digit ZIP code.'
		else
			@locations, @results_text = Organization.find_by_keyword_and_location(keyword, address, radius)
		end
	end

	def show
		@org = Organization.find(params[:id])
		@nearby = @org.nearbys(2)
	end
end