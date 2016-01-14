class PagesController < ApplicationController
  layout '8stem'

	def lbstatus
		render :text => 'ok', :layout => false
	end

  def splash
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
