class AboutController < ApplicationController
	respond_to :html, :json, :js

  def index

  	if request.xhr?
  		FeedbackMailer.send_feedback(params).deliver
  	end

  	respond_to do |format|
  		format.json { render :json => {'test'=>'test'} }
      format.html
    end

  end
end
