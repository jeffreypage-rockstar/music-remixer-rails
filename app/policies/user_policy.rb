class UserPolicy < ApplicationPolicy
  def follow?
    not record.nil? or (user.follows?(record) or user.id == record.id)
  end

  def unfollow?
    !record.nil? and !user.nil? and user.follows?(record)
  end
end
