class AboutController < ApplicationController
  respond_to :html, :json

  def index

    # feedback request, send a feedback mail
    if request.xhr?
      FeedbackMailer.send_feedback(params).deliver
    end

    respond_to do |format|

       # JSON response is for the feedback form.
       # No content needs to be returned, it just needs a response.
       format.json { render :json => {} }

      format.html
    end

  end
end
