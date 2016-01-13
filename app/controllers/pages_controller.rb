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
end
