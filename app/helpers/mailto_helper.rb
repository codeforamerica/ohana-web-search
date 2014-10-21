module MailtoHelper
  # Generate a mailto URL for a share via email link.
  # @return [String] A mailto URL with subject and body filled in.
  def mailto_url
    "mailto:?Subject=#{subject}&body=#{body}"
  end

  # @return [String] A subject line for a mailto URL.
  def subject
    t(
      'views.share.email.subject',
      location_name: @location.name,
      site_title: SETTINGS[:site_title]
    )
  end

  # @return [String] The body for a mailto URL.
  def body
    t(
      'views.share.email.body',
      location_name: @location.name,
      location_url: request.original_url
    )
  end
end
