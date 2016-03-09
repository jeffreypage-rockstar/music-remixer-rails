class SongMixaudioMix3Uploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  before :cache, :save_duration

  process encode_audio: [:m4a]
  process encode_audio: [:mp3]
  process :generate_waveform

  def save_duration(file)
    cmd = "ffprobe -i \"#{file.path}\" -show_entries format=duration -of default=nk=1:nw=1 -v warning"
    model.duration = `#{cmd}`
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

  def encode_audio(format)
    directory = File.dirname(current_path)
    tmpfile = File.join(directory, 'tmpfile')
    Rails.logger.info "SongMixaudioMix3Uploader::encode_audio(#{format}) starting, tmpfile=#{tmpfile}"
    FileUtils.cp(current_path, tmpfile)

    file = ::FFMPEG::Movie.new(tmpfile)
    new_name = File.basename(current_path, '.*') + '.' + format.to_s
    current_extension = File.extname(current_path).gsub('.', '')
    encoded_file = File.join(directory, new_name)

    file.transcode(encoded_file)

    if format == :m4a
      self.filename[-current_extension.size..-1] = format.to_s
      self.file.file[-current_extension.size..-1] = format.to_s
    end
    Rails.logger.info "SongMixaudioMix3Uploader::encode_audio(#{format}) ended, tmpfile=#{tmpfile}"
  end

  def generate_waveform
    directory = File.dirname(current_path)
    Rails.logger.info "SongMixaudioMix3Uploader::generate_waveform starting, directory=#{directory}"

    waveform_line = Cocaine::CommandLine.new('audiowaveform', '-i :input -s :start -e :end -w :width -h :height -o :output --no-axis-labels --waveform-color :waveform_color --background-color :background_color')
    interpolations = {
        input: File.join(directory, File.basename(current_path, '.*') + '.mp3'),
        start: 0,
        end: model.duration,
        width: 640,
        height: 160,
        output: File.join(directory, 'waveform.png'),
        waveform_color: 'aaaaaa',
        background_color: 'ffffff00' # weird, but this makes it transparent
    }

    begin
      waveform_line.run(interpolations)
      self.model.waveform_mix3 = File.open(interpolations[:output])
    rescue Cocaine::ExitStatusError => e
      Rails.logger.info "error while running command #{waveform_line.command(interpolations)}: #{e}"
    end

    waveform_data_line = Cocaine::CommandLine.new('audiowaveform', '-i :input -o :output -z :samples_per_pixel')
    interpolations = {
        input: File.join(directory, File.basename(current_path, '.*') + '.mp3'),
        output: File.join(directory, 'waveform.json'),
        samples_per_pixel: 128
    }
    begin
      waveform_data_line.run(interpolations)
      self.model.waveform_data_mix3 = File.open(interpolations[:output])
    rescue Cocaine::ExitStatusError => e
      Rails.logger.info "error while running command #{waveform_data_line.command}: #{e}"
    end
    Rails.logger.info "SongMixaudioMix3Uploader::generate_waveform ended, directory=#{directory}"
  end
end
