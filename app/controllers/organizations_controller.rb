class OrganizationsController < ApplicationController
	def index
		@organizations = Organization.all
		address = params[:address]
	  @locations = Organization.near(address, 5)
    @results_count = "#{@locations.size} results within 5 miles of #{address}"
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