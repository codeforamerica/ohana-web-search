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
      location_name: full_name_for(@location),
      site_title: SETTINGS[:site_title]
    )
  end

  # @return [String] The body for a mailto URL.
  def body
    t(
      'views.share.email.body',
      location_name: full_name_for(@location),
      location_url: request.original_url
    )
  end

  # @param location [Sawyer::Resource] Location Hash returned by API wrapper.
  # @return [String] The location's name + alternate name if it has one.
  def full_name_for(location)
    if location.alternate_name.present?
      return "#{location.name} (#{location.alternate_name})"
    end
    location.name
  end
end
