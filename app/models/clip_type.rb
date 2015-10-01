class ClipType < ActiveRecord::Base
	default_scope { order('row') }
	
	belongs_to :song

	def self.index type = nil
		clipTypeNames = ["vocals", "bass", "drums", "instruments", "upperc", "dtperc", "dive", "crash"]
		match = clipTypeNames.find { |n| n.match(type) }
		match_index = clipTypeNames.index(match)
		match_index + 1
	end
end
