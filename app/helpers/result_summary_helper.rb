module ResultSummaryHelper                       
	extend ActionView::Helpers::TextHelper

  # Formats search result summary text
  # @param params [Hash] Contains optional count, keyword, location, and radius values
  # @return [String] Result summary string for display on search results view.
	def self.format(params)

		result_count, keyword, location, radius = params[:count], params[:keyword], params[:location], params[:radius]
		
		#set default values
		if result_count.blank?
			result_count = 0
		end
		if radius.blank? 
			radius = 2 #set radius default
		end

		returnVal = self.pluralize(result_count, 'result')
		
		if keyword.present?
			returnVal +=  " matching '#{keyword}'"
		end
			
		if location.present?
			returnVal +=  " within #{self.pluralize(radius, 'mile')} of '#{location}'"
		end

=begin
		# uncomment to add text to unfiltered search result summary text
		if keyword.blank? && location.blank?
			returnVal = "Browse #{returnVal}"
		end
=end

		return returnVal
	end
end