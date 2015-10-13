class PagesController < ApplicationController
  def splash
    @beta_user = BetaUser.new
  end
end
