module ApplicationHelper
	def flash_class(level)
	    case level
		    when :notice then "alert alert-info"
		    when :success then "alert alert-success"
		    when :error then "alert alert-danger"
		    when :alert then "alert alert-danger"
	    end
	end

	def title(page_title)
		content_for(:title) { page_title }
	end

	def provider_name(provider)
		case provider
			when 'google_oauth2'
				'Google+'
			when 'soundcloud'
				'SoundCloud'
			when 'lastfm'
				'Last.fm'
			else
				provider.titleize
		end
	end

	def provider_icon(provider)
		case provider
			when 'google_oauth2'
				'google-plus'
			else
				provider
		end
	end

	def provider_btn_class(provider)
		case provider
			when 'google_oauth2'
				'btn-google-plus'
			else
				"btn-#{provider}"
		end

	def sortable(column, title = nil)
		title ||= column.titleize
		css_class = column == sort_column ? "current #{sort_direction}" : nil
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		arrow = case direction
							when 'asc'
								fa_icon 'caret-up'
							when 'desc'
								fa_icon 'caret-down'
						end
		title_with_arrow = "#{title} #{arrow}"
		link_to title_with_arrow.html_safe, {:sort => column, :direction => direction}, {:class => css_class}
	end
end
