module FormatPhoneHelper
	# Format phone number as (XXX) XXX-XXXX
	def format_phone(number)
		
		if !number.present? 
			raise "No number supplied"
		end
	  
	  result = number.gsub(/[^\d]/, '')
		
		if result.length > 10
			raise "The number has greater than 10 digits"
		end

		if result.length < 10
			raise "The number has less than 10 digits"
		end

	  "(#{result[0..2]}) #{result[3..5]}-#{result[6..10]}"
	end
end