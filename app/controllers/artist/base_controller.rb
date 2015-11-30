class Artist::BaseController < ApplicationController
  before_action :require_login
  before_action :set_artist

  private
  def set_artist
    @artist = current_user.decorate
  end
end