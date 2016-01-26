class App::BaseController < ApplicationController
  before_action :require_login, :except => [:join, :apply, :new, :create, :confirm_email, :thanks]
end