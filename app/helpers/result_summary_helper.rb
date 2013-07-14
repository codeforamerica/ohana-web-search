module ResultSummaryHelper
  extend ActionView::Helpers::TextHelper

  # Formats search result summary text
  # @param params [Hash] Contains optional count, keyword, location,
  # and radius values
  # @return [String] Result summary string for display on search results view.
  def format_summary(params)

    result_count, total_count, keyword, location, radius =
      params[:count], params[:total_count], params[:keyword],
      params[:location], params[:radius]

    #set default values
    result_count = 0 if result_count.blank?

    #set radius default
    radius = 2 if radius.blank?

    summary = "Showing #{result_count} of "
    summary << self.pluralize(total_count, 'result')

    summary << " matching '#{keyword}'" if keyword.present?

    if location.present?
      summary << " within #{self.pluralize(radius, 'mile')} of '#{location}'"
    end

=begin
    # uncomment to add text to unfiltered search result summary text
    if keyword.blank? && location.blank?
      summary = "Browse #{summary}"
    end
=end
    summary
  end

  # def format_pagination(pagination)
  #   items_total = pagination.items_total          #total items
  #   items_current = pagination.items_current      #total items on current page
  #   items_per_page = pagination.items_per_page    #total items per page
  #   pages_total = pagination.pages_total          #total pages

  #   summary = "#{pagination.current} of #{pages_total}"
  # end
end