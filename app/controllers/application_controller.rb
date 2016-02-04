require "application_responder"

# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include Clearance::Controller
  include PublicActivity::StoreController
	include Pundit

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, :except => 'lbstatus'

  # before_action :http_basic_auth, :except => 'lbstatus'

  def http_basic_auth
    return true if Rails.env.development? || Rails.env.test?
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

	def respond_modal_with(*args, &blk)
		options = args.extract_options!
		options[:responder] = ModalResponder
		respond_with *args, options, &blk
	end

	private

	def user_not_authorized
		flash[:alert] = "You are not authorized to perform this action."
		redirect_to(request.referrer || root_path)
	end
end
