class FeedbackMailer < ApplicationMailer
  # Prepares email based on contents of feedback form.
  # See app/views/feedback_mailer/feedback_email.html.haml for the email body.
  # @param params [Hash] Email attributes (from, message, user agent)
  def feedback_email(params = {})
    @message    = params[:message] || '[no message entered]'
    from        = ENV.fetch('EMAIL_SENDER', 'mtcastro@smcgov.org')
    @submitter = params[:from].presence || '[no email entered]'
    @user_agent = params[:agent] || '[no user agent recorded]'

    mail(from: from, subject: "[#{SETTINGS[:site_title]} Feedback]")
  end
end
