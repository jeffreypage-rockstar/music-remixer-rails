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
	end
end
