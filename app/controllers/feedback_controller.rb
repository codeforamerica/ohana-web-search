class FeedbackController < ApplicationController
  def create
    if result.valid?
      FeedbackMailer.feedback_email(feedback_params).deliver_now
      redirect_to root_url, notice: t('views.feedback.confirmation')
    else
      redirect_to about_url(anchor: 'feedback-box'), error: result.error
    end
  end

  private

  def result
    @result ||= Feedback.new(
      email: feedback_params[:from],
      message: feedback_params[:message],
      recaptcha: verify_recaptcha
    )
  end

  def feedback_params
    params.permit(:agent, :from, :message)
  end
end
