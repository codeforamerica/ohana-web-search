class MapSummary
  def initialize(search)
    @search = search
  end

  # rubocop:disable Rails/OutputSafety
  def call
    return if map_data.empty?

    return '' if total_map_markers == total_results

    " <i class='fa fa-map-marker'></i> <em>" \
    "<strong>#{total_map_markers}</strong>/#{total_results} " \
    "located on map</em>".html_safe
  end
  # rubocop:enable Rails/OutputSafety

  private

  attr_reader :search

  def total_results
    @total_results ||= search.locations.size
  end

  def total_map_markers
    @total_map_markers ||= map_data.size
  end

  def map_data
    @map_data ||= search.map_data
  end
end
