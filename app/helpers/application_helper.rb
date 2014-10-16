module ApplicationHelper
  # Appends the site title to the end of the page title.
  # The site title is defined in config/settings.yml.
  # @param page_title [String] the page title from a particular view.
  def title(page_title)
    site_title = SETTINGS[:site_title]
    if page_title.present?
      content_for :title, "#{page_title} | #{site_title}"
    else
      content_for :title, site_title
    end
  end

  # Since this app includes various parameters in the URL when linking to a
  # location's details page, we can end up with many URLs that display the
  # same content. To gain more control over which URL appears in Google search
  # results, we can use the <link> element with the 'rel=canonical' attribute.

  # This helper allows us to set the canonical URL for the details page in the
  # view. See app/views/locations/show.html.haml
  #
  # More info: https://support.google.com/webmasters/answer/139066
  def canonical(url)
    content_for(:canonical, tag(:link, rel: :canonical, href: url)) if url
  end

  # This is the list of environment variables found in config/application.yml
  # that we wish to pass to JavaScript and access through the interface in
  # assets/javascripts/util/environmentVariables.js
  def environment_variables
    raw({
      DOMAIN_NAME: ENV['DOMAIN_NAME'],
      GOOGLE_MAPS_API_KEY: ENV['GOOGLE_MAPS_API_KEY']
    }.to_json)
  end
end
