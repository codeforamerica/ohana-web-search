module SuperscriptFormatHelper

	# Adds <sup>XX</sup> around ordinals
	def superscript_ordinals(string)
		fname = string.split(/(^.*\d)(th)(\b.*)/)

		parsed = ''
		fname.each do |snippet|
						
			if snippet == 'th'
				snippet = '<>th</sup>'
			end

			parsed += snippet

		end

		parsed
	end
end