class ApplicationController < ActionController::Base
	protect_from_forgery

	# make datalist initializer available to all controllers
	before_filter :datalist_initializer

	private

	# retrieve data for datalists used in the search form autocomplete 
	# from the Organization controller
	def datalist_initializer
		@keywords = Organization.keywords
  	@locations = Organization.locations
  end

end
