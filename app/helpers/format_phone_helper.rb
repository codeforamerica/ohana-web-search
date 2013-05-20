module FormatPhoneHelper
	# Format phone number as (XXX) XXX-XXXX
	def format_phone(number)
	  result = number.gsub(/[^\d]/, '')
	  "(#{result[0..2]}) #{result[3..5]}-#{result[6..10]}"
	end
end