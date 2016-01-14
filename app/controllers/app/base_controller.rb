class App::BaseController < ApplicationController
  before_action :require_login, :except => [:new, :create, :confirm_email, :thanks]
end