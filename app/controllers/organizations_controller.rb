class OrganizationsController < ApplicationController
	def index
		params[:miles] = 5 if params[:miles].blank?
    
    if params[:address].present?
			address = params[:address]
		  @locations = Organization.near(address, params[:miles])
	    @results_count = "#{@locations.size} results within #{params[:miles]} miles of #{address}"
	  else
	  	@locations = Organization.all.sort_by(&:name)
	  	@results_count = "#{@locations.size} total results"
	  end
	end

	def show
		@org = Organization.find(params[:id])
		@nearby = @org.nearbys(2)
	end
end