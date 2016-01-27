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
			when 'google'
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
			when 'google'
				'google-plus'
			else
				provider
		end
	end

	def provider_btn_class(provider)
		case provider
			when 'google'
				'btn-google-plus'
			else
				"btn-#{provider}"
		end
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

	def nav_class(layout)
		if layout == 'mix8'
			'navbar navbar-default navbar-fixed-top'
		else
			'navbar navbar-inverse navbar-fixed-top'
		end
	end

	def layout(layout_name)
		controller.class.send(:layout, layout_name)
	end

	def welcome_description(user)
		if user.beta_user.phone_type == 0
			return 'The 8Stem Beta is being set up in our testing program. We’ll be in touch soon with your access information. In the meantime, click on the link below to fill out your	Profile Page.'
		else
			return 'We are currently running the iPhone beta test. But Android is next! We’ll be in touch soon when the Android beta is ready to begin. In the meantime, click on the link below to fill out your Profile Page.'
		end
	end
end
