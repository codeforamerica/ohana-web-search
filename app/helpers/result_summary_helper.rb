module ResultSummaryHelper
  extend ActionView::Helpers::TextHelper

  # Formats search result summary text
  # @param params [Hash] Contains last request params
  # @return [String] Result summary string for display on search results view.
  def format_summary(params)

    keyword, location, radius =
      params[:keyword],
      params[:location],
      params[:radius]

    #set radius default
    radius = 5 if radius.blank?

    summary = "Search returned #{@current_count} of "
    summary << self.pluralize(@total_count, 'result')

    summary << " matching '#{keyword}'" if keyword.present?

    if location.present?
      summary << " within #{self.pluralize(radius, 'mile')} of '#{location}'"
    end

    summary
  end

  def format_map_summary
    if @current_map_count == @total_map_count
      summary = ""
    else
      summary = " | #{@current_map_count} of #{@total_map_count} located on map"
    end
  end

end