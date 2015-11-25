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
