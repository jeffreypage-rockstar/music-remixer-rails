class ClipFileUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  before :cache, :save_duration
  before :cache, :save_original_filename

  process encode_audio: [:ogg]
  process encode_audio: [:m4a]

  def save_duration(file)
    cmd = "ffprobe -i \"#{file.path}\" -show_entries format=duration -of default=nk=1:nw=1 -v warning"
    model.duration = `#{cmd}`
  end

  def save_original_filename(file)
    model.original_filename ||= file.original_filename if file.respond_to?(:original_filename)
  end

  # Override the directory where uploaded files will be stored.
  def store_dir
    env = Rails.env.staging? ? 'production' : Rails.env
    "#{env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.uuid}"
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

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    Song::ACCEPTED_CLIP_FORMATS
  end

  def filename
    "#{secure_token(16)}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

  def encode_audio(format)
    Rails.logger.info  "ClipFileUploader::encode_audio(#{format}) starting"
    directory = File.dirname(current_path)
    tmpfile = File.join(directory, 'tmpfile')
    FileUtils.cp(current_path, tmpfile)

    # fade params
    fade = 0.007
    duration = self.model.duration
    out_start = (duration.to_f - fade).round(5)
    Rails.logger.info  "out_start: #{out_start}"

    # do transcode with fade
    file = ::FFMPEG::Movie.new(tmpfile)
    new_name = File.basename(current_path, '.*') + '.' + format.to_s
    current_extension = File.extname(current_path).gsub('.', '')
    encoded_file = File.join(directory, new_name)
    options = "-af afade=t=in:st=0:d=#{fade},afade=t=out:st=#{out_start}:d=#{fade} -y -v warning"
    Rails.logger.info  "transcoding file from #{current_extension} to #{format} using options #{options}"
    file.transcode(encoded_file, options) { |progress| Rails.logger.info  progress }

    if format == :ogg
      Rails.logger.info  "renaming filename..."
      self.filename[-current_extension.size..-1] = format.to_s
      self.file.file[-current_extension.size..-1] = format.to_s
    elsif format == :m4a
      Rails.logger.info  "setting file_aac..."
      self.model.file_aac = File.open(encoded_file)
    else
      Rails.logger.info  "format #{format.inspect} did not match"
    end
    Rails.logger.info  "ClipFileUploader::encode_audio(#{format}) ended"
  end
end
