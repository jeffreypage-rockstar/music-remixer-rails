class SongMixaudioMix2Uploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay
  before :cache, :save_duration

  process encode_audio: [:m4a]
  process encode_audio: [:mp3, false]
  process :generate_waveform

  def save_duration(file)
    file = ::FFMPEG::Movie.new(file.path)
    model.duration = file.duration
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

  def encode_audio(format='m4a', overwrite=true)
    directory = File.dirname(current_path)
    tmpfile = File.join(directory, 'tmpfile')
    if overwrite
      FileUtils.mv(current_path, tmpfile)
    else
      FileUtils.cp(current_path, tmpfile)
    end

    file = ::FFMPEG::Movie.new(tmpfile)
    new_name = File.basename(current_path, '.*') + '.' + format.to_s
    current_extension = File.extname(current_path).gsub('.', '')
    encoded_file = File.join(directory, new_name)

    file.transcode(encoded_file)

    if overwrite
      self.filename[-current_extension.size..-1] = format.to_s
      self.file.file[-current_extension.size..-1] = format.to_s

      File.delete(tmpfile)
    end
  end

  def generate_waveform
    directory = File.dirname(current_path)

    waveform_line = Cocaine::CommandLine.new('audiowaveform', '-i :input -s :start -e :end -w :width -h :height -o :output --no-axis-labels --waveform-color :waveform_color --background-color :background_color')
    interpolations = {
        input: File.join(directory, File.basename(current_path, '.*') + '.mp3'),
        start: 0,
        end: model.duration,
        width: 640,
        height: 160,
        output: File.join(directory, 'waveform.png'),
        waveform_color: 'aaaaaa',
        background_color: 'ffffff00'
    }

    begin
      waveform_line.run(interpolations)
      self.model.waveform_mix2 = File.open(interpolations[:output])
    rescue Cocaine::ExitStatusError => e
      puts "error while running command #{waveform_line.command(interpolations)}: #{e}"
    end

    waveform_data_line = Cocaine::CommandLine.new('audiowaveform', '-i :input -o :output -z :samples_per_pixel')
    interpolations = {
        input: File.join(directory, File.basename(current_path, '.*') + '.mp3'),
        output: File.join(directory, 'waveform.json'),
        samples_per_pixel: 128
    }
    begin
      waveform_data_line.run(interpolations)
      self.model.waveform_data_mix2 = File.open(interpolations[:output])
    rescue Cocaine::ExitStatusError => e
      puts "error while running command #{waveform_data_line.command}: #{e}"
    end
  end
end
