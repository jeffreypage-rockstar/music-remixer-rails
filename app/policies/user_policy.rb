class UserPolicy < ApplicationPolicy
  def follow?
    not (user.follows?(record) or user.id == record.id)
  end

  def unfollow?
    user.follows?(record)
  end
end
