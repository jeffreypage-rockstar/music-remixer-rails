class Clip < ActiveRecord::Base
	default_scope { order('row') }
	mount_uploader :file, ClipFileUploader

	belongs_to :song
	belongs_to :part
	
	scope :exist, ->(row, column) { where(row: row, column: column) }

	def wing
		fileName = self.file.to_s.split("/").last
		if fileName[0] =~ /[0-9]/
			levelType = fileName.split(".").first.gsub(/\d|O-/,"").gsub("-"," ")
		else 
			levelType = fileName.split("_").first.gsub('O-','').gsub('-',' ')
		end
		levelType.gsub(' ','-').downcase
	end
end
