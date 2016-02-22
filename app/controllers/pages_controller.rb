class PagesController < ApplicationController
  layout '8stem'

	def lbstatus
		render :text => 'ok', :layout => false
	end

  def splash
    # do we really want to do this?
    # if signed_in? && request.env["HTTP_REFERER"].blank?
    #   redirect_to app_home_url
    #   return
    # end
  end

  def about
  end

  def news
  end

  def contact
  end

  def redirect_sign_in
    redirect_to app_sign_in_url
  end
end
