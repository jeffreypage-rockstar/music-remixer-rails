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

  # event_tracker gem
  around_filter :append_event_tracking_tags
  def mixpanel_distinct_id
    current_user ? current_user.uuid : session.id
  end

  before_action :http_basic_auth, :except => 'lbstatus'

  before_filter :beforeFilter
  def beforeFilter
    # set request in a global variable (boo-yeah!)
    $request = request
  end

  def http_basic_auth
    # basic auth only on staging server
    return true unless Rails.env.staging?
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

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render_404
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404",
                           :layout => false,
                           :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
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
