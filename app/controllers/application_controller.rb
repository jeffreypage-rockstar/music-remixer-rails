# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
class ApplicationController < ActionController::Base
  include Clearance::Controller
  include PublicActivity::StoreController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :except => 'lbstatus'

  before_action :http_basic_auth, :except => 'lbstatus'

  def http_basic_auth
	  if request.subdomain == ''
		  authenticate_or_request_with_http_basic("Administration") do |user,pass|
			  # user == ENV["WEBSITE_USERNAME"] && pass = ENV["WEBSITE_PASSWORD"]
			  user == '8stem' && pass == 'mixer8'
		  end
	  elsif request.subdomain == 'admin'
		  authenticate_or_request_with_http_basic("Administration") do |user,pass|
			  # user == ENV["WEBSITE_USERNAME"] && pass = ENV["WEBSITE_PASSWORD"]
			  user == '8stem' && pass == 'admin8'
		  end
	  end
  end
end
