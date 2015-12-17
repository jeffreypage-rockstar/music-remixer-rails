GrapeSwaggerRails.options.url      = '/swagger_doc'
GrapeSwaggerRails.options.app_url  = "#{Rails.application.secrets.api_host_url}"
GrapeSwaggerRails.options.app_name = 'Akashic-nga'
GrapeSwaggerRails.options.before_filter do |request|
  current_user = request.env[:clearance].current_user

  unless current_user && current_user.admin?
    redirect_to main_app.sign_in_url, notice: 'You are not allowed to access the page'
  end
end