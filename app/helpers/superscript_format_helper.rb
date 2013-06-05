module SuperscriptFormatHelper

	# Adds <sup>XX</sup> around ordinals
	def superscript_ordinals(ordinal)
		parse(ordinal)
	end

	private 
	def parse(ordinal)
		regex = '/(^.*\d)('+ordinal+')(\b.*)/'
		fname = string.split(regex)

		parsed = ''
		fname.each do |snippet|
						
			if snippet == ordinal
				snippet = '<sup>'+ordinal+'</sup>'
			end

			parsed += snippet

		end

		parsed
	end

end