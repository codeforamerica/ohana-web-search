class FeedbackMailer < ActionMailer::Base

  default to: SETTINGS.try(:[], :feedback_email).try(:[], 'to')

  # Sends contents of feedback form via email, including user agent
  # @param params [Hash] Email attributes (from, message, user agent)
  # @return [Object] Email object
  def send_feedback(params={})
    message    = params[:message] || '[no message entered]'
    from       = params[:from].blank? ? "anonymous@none.com" : params[:from]
    user_agent = params[:agent] || '[no user agent recorded]'
    url        = ENV['CANONICAL_URL']
    site_title = SETTINGS[:site_title]

    subject = "[#{site_title} Feedback] #{from}"
    body    = "#{message}\n\n----------\n#{user_agent}" \
              "\n\nURL: #{url}"

    mail(
      from: from,
      subject: subject,
      body: body)
  end
end
