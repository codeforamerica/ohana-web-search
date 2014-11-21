module ResultSummaryHelper
  extend ActionView::Helpers::TextHelper

  def search_results_page_title
    search_terms = request.query_parameters.except(:utf8).
                   map { |k, v| "#{k}: #{v}" unless v.blank? }.
                   compact.join(', ')
    title = "Search results for: #{search_terms}"
    title.html_safe
  end

  # Formats map result summary text
  # @return [String] Result summary string for display on search results view.
  def map_summary
    total_results = @search.locations.size
    total_map_markers = @search.map_data.size
    if total_map_markers == total_results
      summary = ''
    else
      summary = " <i class='fa fa-map-marker'></i> <em>"\
                "<strong>#{total_map_markers}</strong>/#{total_results} "\
                'located on map</em>'
    end
    summary.html_safe
  end
end
