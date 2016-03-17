# create a server-side tracker object for mixpanel
$tracker = Mixpanel::Tracker.new(Rails.application.secrets.mixpanel_token) do |type, message|
  mixpanel = Mixpanel::Consumer.new
  mixpanel.send!(type, message)
  Rails.logger.info "MIXPANEL DEBUG: #{type} : #{message}"
end
