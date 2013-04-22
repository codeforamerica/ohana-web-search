class OrganizationsController < ApplicationController
	def index
		@organizations = Organization.all
	end

	def show
		@org = Organization.find(params[:id])
	end
end