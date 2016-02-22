class ClipFileUploaderBase < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay

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
    directory = File.dirname(current_path)
    tmpfile = File.join(directory, 'tmpfile')
    Rails.logger.info  "ClipFileUploaderBase::encode_audio(#{format}) starting on #{tmpfile}"
    Rails.logger.info  "ClipFileUploaderBase::encode_audio(#{format}) cp(#{current_path}, #{tmpfile})"
    # cp(.../public/uploads/tmp/1455696401-56838-3857/A_5.m4a, .../public/uploads/tmp/1455696401-56838-3857/tmpfile)
    FileUtils.cp(current_path, tmpfile)

    # fade params
    fade = 0.007
    duration = self.model.duration
    out_start = (duration.to_f - fade).round(5)
    Rails.logger.info "fade: #{fade}, duration: #{duration}, out_start: #{out_start} for #{tmpfile}"

    # do transcode with fade
    file = ::FFMPEG::Movie.new(tmpfile)
    new_name = File.basename(self.filename, '.*') + '.' + format.to_s
    current_extension = File.extname(current_path).gsub('.', '')
    encoded_file = File.join(directory, new_name)
    options = "-af afade=t=in:st=0:d=#{fade},afade=t=out:st=#{out_start}:d=#{fade} -y -v warning"

    Rails.logger.info "transcoding file #{tmpfile} to #{encoded_file}, from #{current_extension} to #{format} using options #{options}"
    file.transcode(encoded_file, options)

    Rails.logger.info "format: #{format}, tmpfile: #{tmpfile}, encoded_file: #{encoded_file}"
    Rails.logger.info "file: #{self.file.inspect}, file.file: #{self.file.file.inspect}"

    if format == :ogg
      Rails.logger.info  "before renaming ogg file: filename: #{self.filename}, file: #{self.file.file}"
      self.filename[-current_extension.size..-1] = format.to_s
      #self.file.file[-current_extension.size..-1] = format.to_s
    elsif format == :m4a
      Rails.logger.info  "before renaming m4a file: filename: #{self.filename}, file: #{self.file.file}"
      self.filename[-current_extension.size..-1] = format.to_s
      #self.file.file[-current_extension.size..-1] = format.to_s
      # Rails.logger.info  "setting file_aac..."
      # self.model.file_aac = File.open(encoded_file)
    else
      Rails.logger.info  "format #{format.inspect} did not match"
    end
    Rails.logger.info  "ClipFileUploaderBase::encode_audio(#{format}) ended"
  end
end
