class PagesController < ApplicationController
  def splash
    @user = User.new
  end
end
