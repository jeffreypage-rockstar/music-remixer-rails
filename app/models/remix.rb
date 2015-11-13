class Remix < ActiveRecord::Base
	belongs_to :song
	# do we care about tracking remixes of remixes?
	# belongs_to :parent_remix, foreign_key: 'parent_remix_id'
	# has_many :derivative_remixes, class_name: 'Remix', primary_key: 'id', foreign_key: 'parent_remix_id'
end
