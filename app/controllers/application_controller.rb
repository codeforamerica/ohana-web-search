class ApplicationController < ActionController::Base
	protect_from_forgery

	# make datalist initializer available to all controllers
	before_filter :datalist_initializer

	private

	# retrieve data for datalists used in the search form autocomplete
	# from the Organization controller
	def datalist_initializer

		# Taxonomony of terms for the no found page
		@taxonomy_terms = Organization.taxonomy_terms

		# Emergency terms are displayed on the homepage
    @emergency_terms = Organization.emergency_terms

		# Service terms are displayed on the homepage and the 'no results found' page
		@service_terms = Organization.service_terms

		# Keywords are for the keyword input field datalist
		@keywords = Organization.keywords

		# Locations are for the locations input field datalist
  	@locations = Organization.locations
  end

end
