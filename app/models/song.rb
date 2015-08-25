# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
require 'zip'
class Song < ActiveRecord::Base
	mount_uploader :zipfile, AudioUploader
	
	def read_zip_file
		return nil if self.zipfile.blank?
		return nil unless self.zipfile.url.include?("zip")


		# Folder and Zip file path
		fileUploadPath = self.zipfile.url.gsub(self.zipfile.url.split("/").last,"")
		dirPath = "#{Rails.root}/public#{fileUploadPath}"
		folder = "#{Rails.root}/public#{self.zipfile}"

		# If valid zip file
		return nil unless Song.valid_zip?(folder)

		# Extract file in same folder
		clips = Hash.new
		Zip::File.open(folder) do |zipfile|
			zipfile.each do |file|
				filePath = File.join(dirPath, file.name)
			    FileUtils.mkdir_p(File.dirname(filePath))
			    zipfile.extract(file, filePath) unless File.exist?(filePath)
				
				fileNameWithPath = file.name.to_s
				if fileNameWithPath.include?(".m4a") && !fileNameWithPath.include?("MACOSX")
					fileName = fileNameWithPath.split("/").last				
					levelType = fileName.split("_").first.gsub('O-','').gsub('-',' ')
					rowColumnExtension = fileName.split("_").last
					if rowColumnExtension
						rowColumnValue = rowColumnExtension.split(".").first
						row = rowColumnValue[1]
						column = rowColumnValue[0]
						clips[column] = Array.new if clips[column].blank?
						data = {level: levelType, filePath: "#{fileUploadPath}#{fileNameWithPath}"}
						clips[column].push(data)
					end
				end
			end
		end
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
