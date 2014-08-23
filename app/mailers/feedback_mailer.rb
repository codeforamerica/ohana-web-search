class FeedbackMailer < ActionMailer::Base
  default to: SETTINGS.try(:[], :feedback_email).try(:[], 'to')

  # Prepares email based on contents of feedback form.
  # See app/views/feedback_mailer/feedback_email.html.haml for the email body.
  # @param params [Hash] Email attributes (from, message, user agent)
  def feedback_email(params = {})
    @message    = params[:message] || '[no message entered]'
    from        = params[:from].blank? ? 'anonymous@none.com' : params[:from]
    @user_agent = params[:agent] || '[no user agent recorded]'

    mail(from: from, subject: "[#{SETTINGS[:site_title]} Feedback] #{from}")
  end
end
