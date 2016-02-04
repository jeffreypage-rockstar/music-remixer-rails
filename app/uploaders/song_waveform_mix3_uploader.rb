class SongWaveformMix3Uploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # process crop: '640x80+0+40!'
  #
  # def crop(geometry)
  #   manipulate! do |img|
  #     img.crop(geometry)
  #     img
  #   end
  # end

  # Override the directory where uploaded files will be stored
  def store_dir
    "#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.uuid}"
  end

  def fog_directory
    'public_audio'
  end

  def fog_public
    true
  end

  def asset_host
    Rails.application.secrets.rackspace_audio_asset_host
  end

  # Override the filename of the uploaded files:
  def filename
    "#{secure_token(32)}.#{file.extension}" if original_filename.present?
  end

  def remove!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end
  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

end
