CarrierWave.configure do |config|
  if false # Rails.env.development? || Rails.env.test?
    config.storage = :file
  else
    config.storage = :fog

    config.fog_credentials = {
        provider: 'Rackspace',
        rackspace_username: Rails.application.secrets.rackspace_username,
        rackspace_api_key: Rails.application.secrets.rackspace_api_key,
        rackspace_servicenet: Rails.env.production?,
        rackspace_temp_url_key: Rails.application.secrets.rackspace_temp_url_key,
        rackspace_region: :iad
    }

    config.fog_attributes = {
        access_control_allow_origin: '*'
    }
  end

end