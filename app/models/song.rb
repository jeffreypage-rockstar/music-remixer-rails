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
  mount_uploader :mixaudio, SongMixaudioUploader
  store_in_background :mixaudio, SongProcessWorker
  mount_uploader :zipfile, SongZipfileUploader
  store_in_background :zipfile, SongZipfileUploadWorker

  # songs status
  enum status: {processing: 0, failed: 1, pending: 2, released: 3, archived: 4}

  # artist genres
  acts_as_taggable_on :genres
  acts_as_likeable

  belongs_to :user, counter_cache: true
  has_many :parts, dependent: :delete_all
  has_many :clips, dependent: :delete_all
  has_many :clip_types, dependent: :delete_all

  default_values uuid: SecureRandom.uuid, status: Song.statuses[:pending]

  # audio uploader
  validates :name, presence: true
  validates :zipfile, presence: true, if: Proc.new { |s| s.zipfile_tmp.blank? }
  validate :validate_zip_file, unless: Proc.new { |s| s.zipfile_tmp.blank? }

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
    dir_path = File.dirname self.zipfile_tmp_path
    commands = []
    outputs = []
    ffmpegcmd = "cd #{dir_path} && ffmpeg "
    file_extension = File.extname self.clips.first.file_tmp_path

    self.parts.each do |part|
      clips = part.clips
      clip_file_paths = clips.select { |clip| !clip.state }.map { |clip| clip.file_tmp_path }
      command = clip_file_paths.map { |file_path| "-i '#{file_path}'" }.join ' '

      # If at least a single clip is not mute
      output = "mix_audio_part_#{part.column}#{file_extension}"
      if command.present?
        command += " -filter_complex amix=inputs=#{clip_file_paths.count}:duration=longest:dropout_transition=3,volume=#{clip_file_paths.count} -y '#{output}'"
        command = ffmpegcmd + command
        # If all clips are muted, Create a blank audio
      else
        command = "#{ffmpegcmd} -filter_complex aevalsrc=0 -t #{part.duration+1} -y '#{output}'"
      end
      outputs.push(output)
      commands.push(command)
    end

    result = []
    commands.each_with_index do |command, index|
      puts "EXECUTING command #{index+1}: #{command}"
      result[index] = system command
      if result[index].nil?
        puts "Error was #{$?}"
      elsif result[index]
        puts "===================== You made it! #{index + 1}"
      end
    end

    # File Upload path
    dir_path = File.dirname self.zipfile_tmp_path
    digest = Digest::MD5.hexdigest("#{Time.now}")
    output = "mix-audio-#{digest}#{file_extension}"

    command = outputs.map { |output| "-i '#{output}'" }.join ' '
    command = "#{ffmpegcmd} #{command} -filter_complex concat=n=#{outputs.length}:v=0:a=1 -y '#{output}'"

    puts "EXECUTING command: #{command}"
    result = system command
    if result
      self.mixaudio = File.open File.join(dir_path, output)
    else
      puts "Error was #{$?}"
    end
    self.save!
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

  def build_parts_and_clips
    return unless Song.valid_zip?(self.zipfile_tmp_path)

    # zipfile directory path
    dir_path = File.dirname self.zipfile_tmp_path

    # Open Zip file and read audio clips
    duration = 0
    clip_types = []
    clip_type = nil
    clips = {}

    Zip::File.open(self.zipfile_tmp_path) do |files|

      # read files inside zipfile
      files.each do |file|

        # extract files in zipfile directory
        file_path = File.join(dir_path, file.name)
        files.extract(file, file_path) unless File.exist?(file_path)

        if Song.valid_clip_file? file_path
          file_extension = File.extname(file_path)

          if ACCEPTED_CLIP_FORMATS.map { |format| ".#{format}" }.include? file_extension
            row, column = Song.get_parts_from_filename(file.name)
            row = row.ord - 96 # convert a to 1
            level_type = ClipType.row_name(row)

            clip_file_path = File.join dir_path, file.name.to_s

            # puts "XXX level_type: #{level_type}"
            unless clip_types.include? level_type
              clip_types << level_type
              clip_type = self.clip_types.find_or_initialize_by(name: level_type)
              clip_type.row = row
              # puts "XXX added clip_type: #{clip_type.inspect}"
            end

            TagLib::FileRef.open(file_path) do |fileref|
              unless fileref.nil?
                properties = fileref.audio_properties
                clip_column = clips[column] || {}

                unless clip_column[:part]
                  duration += properties.length
                  part = self.parts.find_or_initialize_by(column: column)
                  part.attributes = {name: "Part #{column}", duration: properties.length}
                  clips[column] = {part: part}
                end

                part = clips[column][:part]

                clip = self.clips.find_or_initialize_by(row: row, column: column)
                clip.attributes = {file: File.open(clip_file_path), part: part}
                clip.clip_type = clip_type
              end
            end
          end
        end
      end
    end
    self.duration = duration
    self.save!
  end

  def self.get_parts_from_filename(filename)
    filename = File.basename(filename).strip.downcase
    re = /^([a-h])\s+([1-8])/
    m = re.match(filename)
    return [m[1], m[2]]
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
