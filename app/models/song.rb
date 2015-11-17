# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
require 'zip'
require 'taglib'
require 'digest/md5'

class Song < ActiveRecord::Base
	include PublicActivity::Model
	# tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil },
	# 		    title: Proc.new { |controller, model| model.title }

	belongs_to :user, counter_cache: true
	has_many :parts, dependent: :delete_all
	has_many :clips, dependent: :delete_all
	has_many :clip_types, dependent: :delete_all

	# artist genres
	acts_as_taggable_on :genres

	# audio uploader
	mount_uploader :zipfile, AudioUploader
	validates :name, :zipfile, presence: true
	validate :validate_zip_file

	after_save :read_song_details
	after_destroy :delete_folder

	def title
		name
	end

	def preview_url
		mixaudio  # TODO: needs to be fully qualified url
	end

	def image
		'/todo.png' # TODO: add image to song, needs to be fully qualified url
	end

	def validate_zip_file
		if self.zipfile.blank? or !self.zipfile.url.include?(".zip")
			errors.add(:zipfile, "Not a valid zip file.")
		elsif 
			# Check for valid zip file
			folder = "#{Rails.root}/public#{self.zipfile.url}"
			errors.add(:zipfile, "Not a valid zip file.") unless Song.valid_zip?(folder)

			# Folder and Zip file path
			fileUploadPath = self.zipfile.url.gsub(self.zipfile.url.split("/").last,"")
			dirPath = "#{Rails.root}/public#{fileUploadPath}"

			# Open Zip file and read audio clips
			fileCount = 0
			accepted_formats = [".m4a", ".mp3", ".aac", ".amr", ".aiff", ".ogg", ".oga", ".wav", ".flac", ".act", ".3gp", ".mp4"]
			Zip::File.open(folder) do |zipfile|
				# Read File details
				zipfile.each do |file|
					filePath = File.join(dirPath, file.name)
					if !File.directory?(filePath) && !filePath.include?("MACOSX") && !filePath.include?(".DS_Store")
						fileExtension = File.extname(filePath)
						if accepted_formats.include? fileExtension
							fileCount += 1	
						end
					end
				end
			end

			unless fileCount == 64
				errors.add(:zipfile, "Zip file does not contains 64 audio clips.")
			end
		end
	end

	def self.valid_zip?(file)
		zip = Zip::File.open(file)
		  true
		rescue StandardError
		  false
		ensure
		  zip.close if zip
	end

	def create_mixed_audio configuration = 'source'
		# Folder and Zip file path
		fileUploadPath = self.zipfile.url.gsub(".zip","")
		dirPath = "#{Rails.root}/public#{fileUploadPath}"

		commands = []
		outputs = []
		fileExtension = ""
		ffmpegcmd = "cd #{dirPath} && ffmpeg"
		@parts = self.parts
		@parts.each_with_index do |part, c|
			command = ""
			count = 0
			clips = part.clips
			clips.each_with_index do |clip, r|
				filePath = File.join(dirPath, clip.file)
				fileExtension = File.extname(filePath)
				fileName = clip.file.split("/").last
				state = nil
				# if configuration == 'style-up'
				# 	state = clip.state2
			 	# elsif configuration == 'style-down'
			 	#   state = clip.state3
			 	# else 
			    	state = clip.state
			    # end
				unless state
					command += " -i '#{fileName}'" 
					count += 1
				end
			end

			# If at least a single clip is not mute
			output = "mix_audio_part_#{part.column}#{fileExtension}"
			if command.present?
				command += " -filter_complex amix=inputs=#{count}:duration=longest:dropout_transition=3,volume=#{count} -y ../#{output}"
				command = ffmpegcmd + command
			# If all clips are muted, Create a blank audio
			else
				command = "#{ffmpegcmd} -filter_complex aevalsrc=0 -t #{part.duration+1} -y ../#{output}"
			end
			outputs.push(output)
			commands.push(command)
		end

		result = []
		commands.each_with_index do |command, index|
			puts command
			result[index] = system command
			if result[index].nil?
			  puts "Error was #{$?}"
			elsif result[index]
			  puts "===================== You made it! #{index + 1}"
			end
		end

		# File Upload path
		fileUploadPath = self.zipfile.url.gsub(self.zipfile.url.split("/").last,"")
		dirPath = "#{Rails.root}/public#{fileUploadPath}"
		
		command = ""
		ffmpegcmd = "cd #{dirPath} && ffmpeg"
		digest = Digest::MD5.hexdigest("#{Time.now}")
		output = "mix-audio-#{digest}#{fileExtension}"
		outputs.each_with_index do |output, index|
			command += " -i #{output}"
		end
		command = "#{ffmpegcmd} #{command} -filter_complex concat=n=#{outputs.length}:v=0:a=1 -y #{output}"

		result = system command
		if result.nil?
		  puts "Error was #{$?}"
		elsif result
		  oldmixedfile = false
	      # if configuration == 'style-up'
	      # 	oldmixedfile = self.mixaudio2.split("/").last if self.mixaudio2.present?
	      # 	self.mixaudio2 = "#{fileUploadPath}#{output}"
	      # elsif configuration == 'style-down'
	      # 	oldmixedfile = self.mixaudio3.split("/").last if self.mixaudio3.present?
	      # 	self.mixaudio3 = "#{fileUploadPath}#{output}"
	      # else 
	      	oldmixedfile = self.mixaudio.split("/").last if self.mixaudio.present?
	      	self.mixaudio = "#{fileUploadPath}#{output}"
	      # end
		  isSaved = self.save
		  system "cd #{dirPath} && rm #{oldmixedfile}" if isSaved && oldmixedfile	
		  system "cd #{dirPath} && rm mix_audio_part_*#{fileExtension}"	
		  return isSaved
		end
	end

	private
		def read_song_details
			return if self.duration.present?
			return nil if self.zipfile.blank?
			return nil unless self.zipfile.url.include?(".zip")

			# Check for valid zip file
			folder = "#{Rails.root}/public#{self.zipfile.url}"
			return nil unless Song.valid_zip?(folder)

			# Folder and Zip file path
			fileUploadPath = self.zipfile.url.gsub(self.zipfile.url.split("/").last,"")
			dirPath = "#{Rails.root}/public#{fileUploadPath}"

			# Open Zip file and read audio clips
			clips = Hash.new
			fileCount = 0
			duration = 0
			clipTypes = []
			accepted_formats = [".m4a", ".mp3", ".aac", ".amr", ".aiff", ".ogg", ".oga", ".wav", ".flac", ".act", ".3gp", ".mp4"]
			Zip::File.open(folder) do |zipfile|
		    # Read File details
				zipfile.each do |file|
					# Extract and write files
					filePath = File.join(dirPath, file.name)
					FileUtils.mkdir_p(File.dirname(filePath))
					zipfile.extract(file, filePath) unless File.exist?(filePath)

					clipFilePath = ""
					if !File.directory?(filePath) && !filePath.include?("MACOSX") && !filePath.include?(".DS_Store")
						fileExtension = File.extname(filePath)
						if accepted_formats.include? fileExtension
							# Collect File info
							fileCount += 1
							fileName = file.name.to_s.split("/").last
							# puts "FILENAME: #{fileName}"
							fileName = Song.standardize_uploaded_filename(fileName)
							# puts "STANDARDIZED FILENAME: #{fileName}"

							levelType = fileName.split("_").first.gsub('O-','').gsub('-',' ')
							# puts "LEVELTYPE: #{levelType}"
							rowColumnExtension = fileName.split("_").last
							# puts "ROWCOLE: #{rowColumnExtension}"
							if rowColumnExtension
								rowColumnValue = rowColumnExtension.split(".").first
								column = rowColumnValue[0]
								row = rowColumnValue[1]
								# clips[column] = Array.new if clips[column].blank?
								clipFilePath = "#{fileUploadPath}#{file.name.to_s}"
								# puts "CLIPFILEPATH: #{clipFilePath}"
								# data = {level: levelType, filePath: "#{fileUploadPath}#{file.name.to_s}"}
								# clips[column].push(data)
							end

							# levelType = levelType.gsub(' ','')
							# row = ClipType.index(levelType.downcase)
							unless clipTypes.include? levelType
								clipTypes.push(levelType)
								clipType = ClipType.find_or_create_by(song_id: self.id, name:levelType, row: row)
							end

							if clips[column].blank?
								TagLib::FileRef.open(filePath) do |fileref|
								  unless fileref.null?
								    properties = fileref.audio_properties
								    duration += properties.length
									part = Part.find_or_create_by(song_id: self.id, name: "Part #{column}", duration: properties.length, column: column)
									clip = Clip.find_or_create_by(song_id: self.id, part_id: part.id, row: row, column: column, file: clipFilePath, state: 0)
									clips[column] = "added"
								  end
								end  # File is automatically closed at block end
							else
								part = Part.find_by(song_id: self.id, column: column)
								clip = Clip.find_or_create_by(song_id: self.id, part_id: part.id, row: row, column: column, file: clipFilePath, state: 0)	
							end
						end
					end
				end
			end
			self.duration = duration
			self.save
		end

		def delete_folder
			fileUploadPath = self.zipfile.url.gsub(self.zipfile.url.split("/").last,"")
			dirPath = "#{Rails.root}/public#{fileUploadPath}"
			system "rm -R #{dirPath}"
		end

		def self.standardize_uploaded_filename(filename)
			filename = File.basename(filename).strip
			# puts "FILENAME BASENAME: #{filename}"

			# 8 - Vox8 - Vox_8a.wav
			# 6- Inst6 - Inst_6c.wav
			# 6-Inst_6c.wav
			# or Inst_6c.wav
			re = /([a-zA-Z0-9]+)_(\d+)([a-zA-Z])\.[a-z0-9A-Z]+$/
			m = re.match(filename)
			# puts m.inspect

			short_file = m[0]	# Vox_1a.wav
			# section = m[1]	# Vox (label)
			# column = m[2].to_i - 1	# 1-8 (column)
			# row = m[3].ord - 97		# a-h (row)

			return short_file
		end

end
