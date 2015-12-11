class PagesController < ApplicationController
	def lbstatus
		render :text => 'ok', :layout => false
	end

  def splash
    if signed_in?
      render :beta_blocker
    else
      @beta_user = BetaUser.new
    end
  end

  def about
  end

  def news
  end

  def contact
  end
end
