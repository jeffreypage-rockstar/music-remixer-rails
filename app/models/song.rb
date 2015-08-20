# Ruby version 2.2.2
# Rails version 4.2.1
# Description: Artist home page   
# Author: @Ravi Prakash Singh :: Email - raviprakash.singh@newgenapps.com 
class Song < ActiveRecord::Base
	require 'zip'
	def self.readzip
		# folder = "public/songs/jai_ambe"
		# Zip::File.open(folder) do |zipfile|
		# 	zipfile.each do |file|
		# 		puts "My zip file is:"
		# 		my_string = file.name.to_s
		# 		if my_string.include? ".m4a"
		# 			puts file.name
		# 		end
		# 	end
		# end
	end
end
