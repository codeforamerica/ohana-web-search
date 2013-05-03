class OrganizationsController < ApplicationController
	def index
		### This is the bad code that is causing the error when you visit /organizations ###
		### It was removed a while back but Ans merged it back into master, so I want to ###
		### write a test to make sure it's caught when running test before future commits. ###
		@organizations = Organization.all
		address = params[:address]
	  @locations = Organization.near(address, 5)
    @results_count = "#{@locations.size} results within 5 miles of #{address}"
    #### end bad code #####

		params[:miles] = 5 if params[:miles].blank?
    
    if params[:address].present?
			address = params[:address]
			if (address =~ /^\d+$/) == 0 && address.length != 5
				redirect_to root_url, :alert => 'Please enter a full address or a valid 5-digit ZIP code.'
			else
			  @locations = Organization.near(address, params[:miles])
		    @results_count = "#{TextHelper.pluralize(@locations.size, 'result')} within #{TextHelper.pluralize(params[:miles], 'mile')} of #{address}"
		  end
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