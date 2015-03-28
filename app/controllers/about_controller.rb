class AboutController < ApplicationController
  def index
    # Send an email based on the contents of the feedback form when submitted.
    FeedbackMailer.feedback_email(params).deliver_now if request.xhr?

    respond_to do |format|
      # JSON response is for the feedback form.
      # No content needs to be returned, it just needs a response.
      format.json { render json: {} }
      format.html
    end
  end
end
