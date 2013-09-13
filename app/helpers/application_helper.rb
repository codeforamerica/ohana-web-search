module ApplicationHelper

	def title(page_title)
		default = "SMC-Connect"
		if page_title.present?
			content_for :title, "#{page_title.to_str} | #{default}"
		else
			content_for :title, default
		end
	end

end
