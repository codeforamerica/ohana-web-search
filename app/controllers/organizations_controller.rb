class OrganizationsController < ApplicationController
	def index
		params[:miles] = 5 if params[:miles].blank?
    
    if params[:address].present?
			address = params[:address]
			# check if address entered only contains digits using regex
			# and if it's not exactly 5 digits, treat it as invalid entry
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