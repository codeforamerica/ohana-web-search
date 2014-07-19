module ResultSummaryHelper
  extend ActionView::Helpers::TextHelper

  def search_results_page_title
    title = page_entries_info @locations_array, entry_name: 'result'
    title.gsub('<strong>', '').gsub('</strong>', '')
  end

  # Formats map result summary text
  # @return [String] Result summary string for display on search results view.
  def format_map_summary
    total_results = @orgs.size
    total_map_markers = @array_for_maps.size
    if total_map_markers == total_results
      summary = ""
    else
      summary = " <i class='fa fa-map-marker'></i> <em><strong>#{total_map_markers}</strong>/#{total_results} located on map</em>"
    end
    summary.html_safe
  end
end
