class ClipType < ActiveRecord::Base
	default_scope { order('row') }
	
	belongs_to :song
end
