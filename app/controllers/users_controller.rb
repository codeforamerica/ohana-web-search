class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :only => [:index, :update, :destroy]
  #before_filter :correct_user?, :except => [:index]

  def index
    #@users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
