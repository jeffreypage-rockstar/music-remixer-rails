class Artist < ActiveRecord::Base
	# artist administration
	belongs_to :user

	# artist song catalog
	has_many :songs
end
