if Rails.env.production?
  $tracker = Mixpanel::Tracker.new(Rails.application.secrets.mixpanel_token)
else
  $tracker = Mixpanel::Tracker.new(Rails.application.secrets.mixpanel_token) do |type, message|
    mixpanel = Mixpanel::Consumer.new
    mixpanel.send!(type, message)
    Rails.logger.debug "MIXPANEL DEBUG: #{type} : #{message}"
  end
end
