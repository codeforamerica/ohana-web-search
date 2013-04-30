class OrganizationsController < ApplicationController
	def index
		@organizations = Organization.all
		address = params[:address]
	  @locations = Organization.near(address, 5)
    @results_count = "#{@locations.size} results within 5 miles of #{address}"
	end

	def show
		@org = Organization.find(params[:id])
		@nearby = @org.nearbys(2)
	end
end