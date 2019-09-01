class LocationMailtoUrl
  def initialize(location, url)
    @location = location
    @url = url
  end

  def call
    "mailto:?Subject=#{subject}&body=#{body}"
  end

  private

  attr_reader :location, :url

  def subject
    I18n.t(
      'views.share.email.subject',
      location_name: location_full_name,
      site_title: SETTINGS[:site_title]
    )
  end

  def body
    I18n.t(
      'views.share.email.body',
      location_name: location_full_name,
      location_url: url
    )
  end

  def location_full_name
    return "#{location.name} (#{location.alternate_name})" if location.alternate_name.present?

    location.name
  end
end
