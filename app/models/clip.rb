class Clip < ActiveRecord::Base
	default_scope { order('row') }
	mount_uploader :file, ClipFileUploader
	store_in_background :file, ClipFileUploadWorker

	enum storing_status: { storing_pending: 0, storing_done: 1, storing_failed: 2 }

	default_values storing_status: Clip.storing_statuses[:storing_pending]
	default_value_for :uuid do
		SecureRandom.uuid
	end

	belongs_to :song
	belongs_to :part
	
	scope :exist, ->(row, column) { where(row: row, column: column) }

	def file_tmp_path
		file_tmp_path = self.file.file.try(:path)

		if file_tmp_path.blank?
			cache_directory = File.expand_path(self.file.cache_dir, self.file.root)
			file_tmp_path = File.join(cache_directory, self.file_tmp)
		end
		file_tmp_path
	end
	
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
