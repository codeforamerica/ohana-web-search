module ResultSummaryHelper
  extend ActionView::Helpers::TextHelper

  # Formats map result summary text
  # @return [String] Result summary string for display on search results view.
  # rubocop:disable Rails/OutputSafety
  def map_summary
    total_results = @search.locations.size
    total_map_markers = @search.map_data.size
    summary = if total_map_markers == total_results
                ''
              else
                " <i class='fa fa-map-marker'></i> <em>"\
                "<strong>#{total_map_markers}</strong>/#{total_results} "\
                "located on map</em>"
              end
    summary.html_safe
  end
  # rubocop:enable Rails/OutputSafety

  def search_results_page_title
    search_terms = request.query_parameters.
                   except(:utf8, :service_area).
                   map { |k, v| "#{k}: #{v}" if v.present? }.
                   compact.join(', ')
    "Search results for: #{search_terms}"
  end

  def location_link_for(location)
    if location.organization.name == location.name
      location_path([location.slug], request.query_parameters)
    else
      location_path([location.organization.slug, location.slug], request.query_parameters)
    end
  end
end
