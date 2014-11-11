module InfoBoxHelper
  # Hash derived from info_box_terms in config/settings.yml.
  # The Hash keys represent the top-level terms, and the values
  # are Hashes representing the various attributes, such as synonyms,
  # title, description, and url.
  #
  # Here is an example Hash that would be returned:
  # { "wic" => {
  #     "synonyms" => ["women, infants, and children", "wic"],
  #     "title" => "Women, Infants, and Children",
  #     "description" => "Women, Infants, and Children (WIC) provides...",
  #     "url" => "http://www.fns.usda.gov/wic"
  #    },
  #   "sfmnp" => {
  #     "synonyms" => ["senior farmers' market nutrition program"],
  #     "title" => "Senior Farmers' Market Nutrition Program",
  #     "description" => "Senior Farmers' Market Nutrition Program (SFMNP)...",
  #     "url" => "http://www.fns.usda.gov/sfmnp"
  #    }
  # }
  #
  # @return [Hash] If key is present, otherwise returns nil.
  def info_box_hash
    SETTINGS.try(:[], :info_box_terms)
  end

  # Returns an array of all the synonyms from the info_box_hash.
  #
  # @return [Array]
  def synonyms
    info_box_hash.values.map { |hash| hash['synonyms'] }.flatten
  end

  # If the search keyword matches a synonym in the info_box_hash,
  # return the top-level key that corresponds to that synonym.
  #
  # @return [String]
  def info_box_key_corresponding_to_keyword
    keyword = params[:keyword].try(:downcase)
    return unless synonyms.include?(keyword)
    info_box_hash.find { |_, hash| hash['synonyms'].include? keyword }.first
  end

  # @param info_box [Hash] Infobox title, description, and link settings.
  # @return [HTML]
  # Returns an HTML description list with the info box's title,
  # description, and a "More info..." link to its URL if it has one defined.
  def render_html_for_generic_info_box(info_box)
    html = content_tag :dl do
      concat(content_tag :dt, info_box['title'])
      concat(content_tag :dd, info_box['description'])
    end
    return html if info_box['url'].blank?
    html.concat(content_tag(:p) do
      link_to('More info...', info_box['url'], target: '_blank')
    end)
  end

  # @param info_box_key [String] Key to look up infobox settings
  #   in config/settings.yml.
  # @return [HTML]
  # If the info box has a "custom" key, render the partial that the
  # "custom" key points to. Otherwise, render the default description list
  # template defined in the method above.
  def render_info_box(info_box_key)
    info_box = info_box_hash[info_box_key]

    if info_box['custom'].present?
      render info_box['custom']
    else
      render_html_for_generic_info_box(info_box)
    end
  end
end
