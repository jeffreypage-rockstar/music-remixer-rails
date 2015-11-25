class RemixDecorator < Draper::Decorator
  delegate_all

  def remixed_by_name
    object.user.name
  end

end
