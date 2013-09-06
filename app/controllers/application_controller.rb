class ApplicationController < ActionController::Base
	protect_from_forgery

	# make datalist initializer available to all controllers
	before_filter :datalist_initializer

	private

	# retrieve data for datalists used in the search form autocomplete
	# from the Organization controller
	def datalist_initializer
		# Program terms are government programs displayed on the homepage
    @program_terms = Organization.program_terms

		@service_terms = Organization.service_terms

		# Keywords are for the keyword input field datalist
		@keywords = Organization.keywords

		# Locations are for the locations input field datalist
  	@locations = Organization.locations
  end

end
