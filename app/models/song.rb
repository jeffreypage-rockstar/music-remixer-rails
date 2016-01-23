# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
require 'zip'
require 'taglib'
require 'digest/md5'

class Song < ActiveRecord::Base
  include ActiveModel::Dirty
  include PublicActivity::Common
  # tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil },
  # 		    title: Proc.new { |controller, model| model.title }

  ACCEPTED_CLIP_FORMATS = %w(m4a mp3 aac amr aiff ogg oga wav flac act 3gp mp4)
  mount_uploader :image, SongImageUploader
  mount_uploader :waveform, SongWaveformUploader
  mount_uploader :waveform_data, SongWaveformDataUploader
  mount_uploader :mixaudio, SongMixaudioUploader
  store_in_background :mixaudio, SongProcessWorker
  mount_uploader :zipfile, SongZipfileUploader
  store_in_background :zipfile, SongZipfileUploadWorker

  # songs status
  enum status: { processing: 0, failed: 1, working: 2, processing_for_release: 3, released: 4, archived: 5 }

  # song genres
  acts_as_taggable_on :genres
  acts_as_likeable

  belongs_to :user, counter_cache: true
  has_many :parts, -> { order 'parts.column' }, dependent: :delete_all
  has_many :clips, dependent: :delete_all
  has_many :clip_types, -> { order 'clip_types.row' }, dependent: :delete_all
  has_many :remixes, -> { order 'plays_count desc'}, dependent: :delete_all

  default_value_for :uuid do #important, needs to be in a block
    SecureRandom.hex(12)
  end
  default_value_for status: Song.statuses[:processing]

  # audio uploader
  validates :name, presence: true
  validates :zipfile, presence: true, if: Proc.new { |s| s.zipfile_tmp.blank? }
  validate :validate_zip_file, if: Proc.new { |s| s.zipfile_tmp.blank? && s.zipfile_changed? }

  def bpm
    self[:bpm].nil? ? 0 : self[:bpm]
  end

  def title
    name
  end

  def preview_url
    mixaudio.url
  end

  def processed?
    self.mixaudio_tmp.blank?
  end

  def zipfile_tmp_path
    zipfile_tmp_path = self.zipfile.file.try(:path)

    if zipfile_tmp_path.blank?
      cache_directory = File.expand_path(self.zipfile.cache_dir, self.zipfile.root)
      zipfile_tmp_path = File.join(cache_directory, self.zipfile_tmp)
    end
    zipfile_tmp_path
  end

  def validate_zip_file
    unless Song.valid_zip?(self.zipfile_tmp_path)
      errors.add(:zipfile, 'Not a valid zip file.')
    else
      Zip::File.open(self.zipfile_tmp_path) do |files|
        file_count = files.count { |file| Song.valid_clip_file? file.name }
        unless file_count > 32
          errors.add(:zipfile, 'Zip file does not contain enough audio clips.')
        end
      end
    end
  end

  def build_mixaudio(configuration='source')
    self.status = Song.statuses[:processing_for_release]
    self.save!
    if self.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      dir_path = self.song_tmp_directory_path
      self.extract_zipfile! unless File.directory?(dir_path)
      part_audio_paths = []
      self.zipfile

      self.parts.each_with_index do |part, index|
        clips = part.clips
        clip_file_paths = clips.select { |clip| !clip.state }.map { |clip| File.join(dir_path, clip.original_filename) }
        part_audio_path = File.join(dir_path, "mix_audio_part_#{part.column}.m4a")

        begin
          interpolations = {output: part_audio_path}
          if clip_file_paths.any?
            input_params = []
            clip_file_paths.each_with_index do |file_path, index|
              input_params << "-i :input#{index}"
              interpolations[:"input#{index}"] = file_path
            end
            interpolations[:filters] = "amix=inputs=#{clip_file_paths.count}:duration=longest:dropout_transition=3"
            part_audio_line = Cocaine::CommandLine.new('ffmpeg', "#{input_params.join(' ')} -filter_complex :filters -y :output")
            puts "Generating part audio #{index+1}: #{part_audio_line.command(interpolations)}"
            part_audio_line.run(interpolations)
          else
            interpolations[:filters] = "aevalsrc=0 -t #{part.duration}"
            part_audio_line = Cocaine::CommandLine.new('ffmpeg', '-filter_complex :filters -y :output')
            puts "Generating part audio #{index+1}: #{part_audio_line.command(interpolations)}"
            part_audio_line.run(interpolations)
          end
        rescue Cocaine::ExitStatusError => e
          puts "error while running command #{part_audio_line.command(interpolations)}: #{e}"
        end
        part_audio_paths << part_audio_path
      end

      digest = Digest::MD5.hexdigest("#{Time.now}")
      interpolations = {output: File.join(dir_path, "mix-audio-#{digest}.m4a")}
      input_params = []
      part_audio_paths.each_with_index do |audio_path, index|
        input_params << "-i :input#{index}"
        interpolations[:"input#{index}"] = audio_path
      end      
      mixaudio_line = Cocaine::CommandLine.new('ffmpeg', "#{input_params.join(' ')} -filter_complex :filters -y :output")     
      interpolations[:filters] = "concat=n=#{part_audio_paths.length}:v=0:a=1"
      
      begin
        puts "Generating mix audio: #{mixaudio_line.command(interpolations)}"
        mixaudio_line.run(interpolations)
        self.mixaudio = File.open(interpolations[:output])
      rescue Cocaine::ExitStatusError => e
        puts "error while running command #{mixaudio_line.command(interpolations)}: #{e}"
      end
    end
    self.save
  end

  def self.valid_zip?(file)
    zip = Zip::File.open(file)
    true
  rescue StandardError
    false
  ensure
    zip.close if zip
  end

  def self.valid_clip_file?(filename)
    ACCEPTED_CLIP_FORMATS.map { |format| ".#{format}" }.include?(File.extname(filename)) && !filename.include?('MACOSX')
  end

  def song_tmp_directory_path
    cache_directory = File.expand_path(self.zipfile.cache_dir, self.zipfile.root)
    File.join(cache_directory, self.uuid)
  end

  def extract_zipfile!

    cache_directory = File.expand_path(self.zipfile.cache_dir, self.zipfile.root)
    dir_path = File.join(cache_directory, self.uuid)
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

    target_file_path = self.zipfile_tmp_path
    # If zipfile_tmp is nil, download zipfile
    if self.zipfile_tmp.nil? && self.zipfile.url
      zipfile_curl_line = Cocaine::CommandLine.new('curl', '-o :output :input')
      interpolations = {
          input: self.zipfile.url,
          output: File.join(dir_path, File.basename(self.zipfile.url))
      }
      begin
        puts "Download zip file: #{zipfile_curl_line.command(interpolations)}"
        zipfile_curl_line.run(interpolations)
        target_file_path = File.join(dir_path, File.basename(self.zipfile.url))
      rescue Cocaine::ExitStatusError => e
        puts "error while running command #{zipfile_curl_line.command}: #{e}"
      end
    end
    Zip::File.open(target_file_path) do |files|
      files.each do |file|
        if Song.valid_clip_file? file.name

          file_path = File.join(dir_path, File.basename(file.name))
          files.extract(file, file_path) unless File.exist?(file_path)
        end
      end
    end
  end

  def build_parts_and_clips
    return unless Song.valid_zip?(self.zipfile_tmp_path)

    # Open Zip file and read audio clips
    parts = {}
    clip_types = {}

    Dir.foreach(self.song_tmp_directory_path) do |file|
      file_path = File.join(self.song_tmp_directory_path, file)

      if Song.valid_clip_file? file_path
        file_extension = File.extname(file_path)
        if ACCEPTED_CLIP_FORMATS.map { |format| ".#{format}" }.include? file_extension
          clip_file_path = File.join self.song_tmp_directory_path, file
          column, row = Song.get_parts_from_filename(file)

          unless clip_types[row]
            level_type = ClipType.row_name(row)
            clip_type = self.clip_types.find_or_initialize_by(name: level_type)
            clip_type.attributes = {row: row}
            clip_types[row] = clip_type
          end

          unless parts[column]
            part = self.parts.find_or_initialize_by(column: column)
            part.attributes = {name: "Part #{column}"}
            parts[column] = part
          end

          clip = self.clips.find_or_initialize_by(row: row, column: column)
          clip.attributes = {file: File.open(clip_file_path), part: parts[column], clip_type: clip_types[row]}
        end
      end
    end
    self.save!
  end

  def self.get_parts_from_filename(filename)
    Rails.logger.info("get_parts_from_filename(#{filename}")
    filename = File.basename(filename).strip.downcase
    re = /^([a-h])\s*([1-8])/
    m = re.match(filename)
    # new new new format, col (a-h) row (1-8)
    col = m[1].ord-96 # convert alpha to numeric
    row = m[2]
    return [col.to_i, row.to_i]
  end

  # script to rename audio files
  def self.rename_files(folder)
    Dir.glob("#{folder}/*").each do |entry|
      filename = File.basename(entry)
      re = /([a-zA-Z0-9]+)_(\d+)([a-zA-Z])\.[a-z0-9A-Z]+$/
      if m = re.match(filename)
        short_file = m[0]
        re = /^([^_]+)_([1-8])([a-h])/
        m = re.match(short_file)
        new_file = "#{m[3].upcase} #{m[2]} #{m[1]}#{File.extname(entry)}"
        puts "original file: #{filename}, new file: #{new_file}"
        File.rename( entry, "#{folder}/#{new_file}")
      else
        puts "skipping #{filename}"
      end
    end
    return false
  end

end
