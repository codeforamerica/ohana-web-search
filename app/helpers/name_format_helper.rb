module NameFormatHelper
  # @param location [Sawyer::Resource] Location Hash returned by API wrapper.
  # @return [String] The location's name + alternate name if it has one,
  # wrapped in span elements.
  def full_name_content_for(location)
    if location.alternate_name.present?
      return "#{name_content_for(location)} (#{alternate_name_content_for(location)})".html_safe
    end
    name_content_for(location)
  end

  # @param location [Sawyer::Resource] Location Hash returned by API wrapper.
  # @return [String] The location's name wrapped in a span element.
  def name_content_for(location)
    content_tag 'span', itemprop: 'legalName' do
      content_tag 'span', itemprop: 'name' do
        location.name
      end
    end
  end

  # @param location [Sawyer::Resource] Location Hash returned by API wrapper.
  # @return [String] The location's alternate name wrapped in a span element.
  def alternate_name_content_for(location)
    content_tag 'span', itemprop: 'alternateName' do
      location.alternate_name
    end
  end
end
