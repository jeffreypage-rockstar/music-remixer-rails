class Artist::BaseController < ApplicationController
  before_action :require_login
  before_action :validate_artist
  before_action :set_artist

  private
  def set_artist
    @artist = current_user.decorate
  end

  def validate_artist
    redirect_to app_home_url unless current_user && current_user.is_artist_admin?
  end
end