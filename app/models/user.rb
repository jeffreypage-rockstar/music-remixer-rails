class User < ActiveRecord::Base
  include Clearance::User

  # artist administration
  has_many :artists

  def admin?
    is_admin
  end

end
