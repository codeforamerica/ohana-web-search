class FeedbackMailer < ActionMailer::Base

  default to: %w[ohanapi@codeforamerica.org]

  # Sends contents of feedback form via email, including user agent
  # @param params [Hash] Email attributes (from, message, user agent)
  # @return [Object] Email object
  def send_feedback(params={})
    message    = params[:message] || '[no message entered]'
    from       = params[:from].blank? ? "anonymous@none.com" : params[:from]
    user_agent = params[:agent] || '[no user agent recorded]'

    subject = "[Ohana Web Search Feedback] #{from}"
    body    = "#{message}\n\n----------\n#{user_agent}"

    mail(
      from: from,
      subject: subject,
      body: body)
  end

end