class UserPolicy < ApplicationPolicy
  def follow?
    user.nil? or (!user.follows?(record) and user.id != record.id)
  end

  def unfollow?
    !user.nil? and user.follows?(record)
  end
end
