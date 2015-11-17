class PagesController < ApplicationController
	def lbstatus
		render :text => 'ok', :layout => false
	end

  def splash
    @beta_user = BetaUser.new
  end
end
