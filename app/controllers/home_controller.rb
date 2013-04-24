class HomeController < ApplicationController
  def index
    @users = User.all
    @organizations = Organization.all
  end
end
