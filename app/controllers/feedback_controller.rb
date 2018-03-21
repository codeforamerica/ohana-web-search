class FeedbackController < ApplicationController
  def create
    FeedbackMailer.feedback_email(feedback_params).deliver_now
    redirect_to root_url, notice: 'Feedback Sent! Thank you!'
  end

  private

  def feedback_params
    params.permit(:agent, :from, :message)
  end
end
