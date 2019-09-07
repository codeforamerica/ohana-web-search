module ResultSummaryHelper
  extend ActionView::Helpers::TextHelper

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
