# encoding: utf-8

class ProfileBackgroundImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  def store_dir
    env = Rails.env.staging? ? 'production' : Rails.env
    "#{env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.uuid}"
  end

  def fog_directory
    'images'
  end

  def fog_public
    true
  end

  def asset_host
    Rails.application.secrets.rackspace_images_asset_host
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.asset_path('fallback/profile_background_image_default.jpg')
  end

  process :resize_to_fill => [1600, 400]

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token(16)}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

end
