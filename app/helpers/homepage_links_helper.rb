module HomepageLinksHelper
  # Hash representing headers and link text in the "general" category
  # of links displayed on the homepage, as defined in config/settings.yml.
  #
  # @return [Hash] Key: String header, Value: Array of link texts.
  def general_links
    SETTINGS.try(:[], :homepage_links).try(:[], 'general')
  end

  # Hash representing headers and link text in the "emergency" category
  # of links displayed on the homepage, as defined in config/settings.yml.
  #
  # @return [Hash] Key: String header, Value: Array of link texts.
  def emergency_links
    SETTINGS.try(:[], :homepage_links).try(:[], 'emergency')
  end

  # If the link text contains words separated by a slash, or if it contains
  # words enclosed in parentheses, it will only return the part of the String
  # that comes before the slash or the parentheses.
  #
  # Example: if "SNAP/Food Stamps" or "SNAP (Food Stamps)" is passed in,
  # it will return "SNAP" in both cases.
  #
  # @param link_text [String] A link text from the bottom half of homepage.
  # @return [String]
  def keyword_from_link_text(link_text)
    ['/', '('].each do |char|
      link_text = link_text.split(char).first.strip if link_text.include?(char)
    end
    link_text
  end

  # Outputs HTML that displays the headers and link text on the bottom half
  # of the homepage. Called in app/views/home/_homepage_links.html.haml.
  #
  # @param link_group [Hash] Key: String header, Value: Array of link texts.
  # @return [HTML]
  def display_homepage_links(link_group)
    content_tag(:li) do
      concat(header_for(link_group))
      concat(content_tag(:ul) do
        list_of_links(links_for(link_group))
      end)
    end
  end

  def header_for(link_group)
    link_group.first
  end

  def links_for(link_group)
    link_group.second
  end

  def list_of_links(links)
    links.each do |link_text|
      concat(content_tag(:li) do
        link_to_keyword(keyword_from_link_text(link_text), link_text)
      end)
    end
  end

  def link_to_keyword(keyword, link_text)
    link_to(
      link_text,
      locations_path(keyword: keyword),
      'class' => 'links-to-track',
      'data-ga-category' => 'Home_Categories',
      'data-ga-label' => "#{link_text}"
    )
  end
end
