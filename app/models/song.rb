# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
require 'zip'
require 'taglib'

class Song < ActiveRecord::Base
	has_many :parts, dependent: :delete_all
	has_many :clips, dependent: :delete_all
	mount_uploader :zipfile, AudioUploader

	validates :name, :zipfile, presence: true
	validate :validate_zip_file

	after_save :read_song_details

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
			accepted_formats = [".m4a", ".mp3", ".aac", ".amr", ".aiff", ".ogg", ".wav", ".flac", ".act", ".3gp", ".mp4"]
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

	def clipState(row = 0, column = 0)
		clip = self.clips.detect {|clip| clip.row == row and clip.column == column }
		return true if !clip or clip.state
		return false
	end

	def concatanate
		# Folder and Zip file path
		fileUploadPath = self.zipfile.url.gsub(".zip","")
		dirPath = "#{Rails.root}/public#{fileUploadPath}"
		puts dirPath

		result = system "cd #{dirPath} && ffmpeg -i O-Bass_1a.m4a -i O-Crash_1b.m4a -i O-Dive_1c.m4a -i O-Drums_1d.m4a -i O-DT-Perc_1e.m4a -i O-Inst_1f.m4a -i 'O-Up Perc_1g.m4a' -i O-Vocals_1h.m4a -filter_complex amix=inputs=8:duration=longest:dropout_transition=3 -y ../ringtone.m4a"
		if result.nil?
		  puts "Error was #{$?}"
		elsif result
		  puts "You made it!"
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
			Zip::File.open(folder) do |zipfile|
			    # Read File details
				zipfile.each do |file|
					# Extract and write files
					filePath = File.join(dirPath, file.name)
					FileUtils.mkdir_p(File.dirname(filePath))
			    	zipfile.extract(file, filePath) unless File.exist?(filePath)

			    	clipFilePath = ""
					if !File.directory?(filePath) && !filePath.include?("MACOSX") && !filePath.include?(".DS_Store")
				    	# Collect File info
						fileCount += 1
						fileName = file.name.to_s.split("/").last
						if fileName[0] =~ /[0-9]/
							column = fileName[0]
							# clips[column] = Array.new if clips[column].blank?
							levelType = fileName.split(".").first.gsub(/\d|O-/,"").gsub("-"," ")
							clipFilePath = "#{fileUploadPath}#{file.name.to_s}"
							# data = {level: levelType, filePath: "#{fileUploadPath}#{file.name.to_s}"}
							# clips[column].push(data)
						else 
							levelType = fileName.split("_").first.gsub('O-','').gsub('-',' ')
							rowColumnExtension = fileName.split("_").last
							if rowColumnExtension
								rowColumnValue = rowColumnExtension.split(".").first
								column = rowColumnValue[0]
								row = rowColumnValue[1]
								# clips[column] = Array.new if clips[column].blank?
								clipFilePath = "#{fileUploadPath}#{file.name.to_s}"
								# data = {level: levelType, filePath: "#{fileUploadPath}#{file.name.to_s}"}
								# clips[column].push(data)
							end
						end

						if clips[column].blank?
							TagLib::FileRef.open(filePath) do |fileref|
							  unless fileref.null?
							    properties = fileref.audio_properties
							    duration += properties.length
								@part = Part.find_or_create_by(song_id: self.id, name: "Part #{column}", duration: properties.length, column: column)
								clips[column] = "added"
							  end
							end  # File is automatically closed at block end
						end
						@part = Part.find_by(song_id: self.id, column: column)
						@clip = Clip.find_or_create_by(song_id: self.id, part_id: @part.id, row: row, column: column, file: clipFilePath, state: 0)
					end
				end
			end
			self.duration = duration
			self.save!
		end
end
