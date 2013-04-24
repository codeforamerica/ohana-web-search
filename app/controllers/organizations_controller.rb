class OrganizationsController < ApplicationController
	def index
		@organizations = Organization.all
	end

	def show
		@org = Organization.find(params[:id])
		@nearby = @org.nearbys(2)
	end
end