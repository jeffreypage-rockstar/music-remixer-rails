class MusicBackground < ActiveRecord::Base
  has_and_belongs_to_many :beta_users

end
