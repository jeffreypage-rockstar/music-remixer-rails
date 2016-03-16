class MixpanelTracker
  @@tracker = Mixpanel::Tracker.new(Rails.application.secrets.mixpanel_token) do |type, message|
    mixpanel = Mixpanel::Consumer.new
    mixpanel.send!(type, message)
    Rails.logger.info "MIXPANEL DEBUG: #{type} : #{message}"
  end

  def self.ip
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
  end

  def self.track(id, label, properties={})
    @@tracker.track id, "Web: #{label}", properties, self.ip
  end

  def self.alias(new_id, old_id)
    @@tracker.alias new_id, old_id
  end

  def self.people_set(id, properties = {})
    @@tracker.people.set id, properties, self.ip
  end
end