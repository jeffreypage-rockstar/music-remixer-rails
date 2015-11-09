# http://jes.al/2013/10/architecting-restful-rails-4-api/
class ApiConstraints
	def initialize(options)
		@version = options[:version]
		@default = options[:default]
	end

	def matches?(req)
		@default || req.headers['Accept'].include?("application/vnd.myapp.v#{@version}")
	end
end
