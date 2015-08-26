# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
require 'zip'
class Song < ActiveRecord::Base
	mount_uploader :zipfile, AudioUploader
	
	has_many :clips, dependent: :delete_all

	def clipState(row = 0, column = 0)
		clip = self.clips.detect {|clip| clip.row == row and clip.column == column }
		return true if !clip or clip.state
		return false
	end

	def readZipFile
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
		Zip::File.open(folder) do |zipfile|
			zipfile.each do |file|
				# Extract zip folder
				filePath = File.join(dirPath, file.name)
			    FileUtils.mkdir_p(File.dirname(filePath))
			    zipfile.extract(file, filePath) unless File.exist?(filePath)
				
				# Get Songs List
				fileNameWithPath = file.name.to_s
				if fileNameWithPath.include?(".m4a") && !fileNameWithPath.include?("MACOSX")
					fileCount += 1
					fileName = fileNameWithPath.split("/").last
					if fileName[0] =~ /[0-9]/
						column = fileName[0]
						clips[column] = Array.new if clips[column].blank?
						levelType = fileName.split(".").first.gsub(/\d|O-/,"").gsub("-"," ")
						data = {level: levelType, filePath: "#{fileUploadPath}#{fileNameWithPath}"}
						clips[column].push(data)
					else 
						levelType = fileName.split("_").first.gsub('O-','').gsub('-',' ')
						rowColumnExtension = fileName.split("_").last
						if rowColumnExtension
							rowColumnValue = rowColumnExtension.split(".").first
							column = rowColumnValue[0]
							clips[column] = Array.new if clips[column].blank?
							data = {level: levelType, filePath: "#{fileUploadPath}#{fileNameWithPath}"}
							clips[column].push(data)
						else
							clips = nil
						end
					end
				end
			end
		end
		clips = nil if fileCount != 64
		clips
	end

	def self.valid_zip?(file)
		zip = Zip::File.open(file)
		  true
		rescue StandardError
		  false
		ensure
		  zip.close if zip
	end
end
