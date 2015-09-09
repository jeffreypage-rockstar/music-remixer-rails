class Part < ActiveRecord::Base
	default_scope { order('column') }

	belongs_to :song
	has_many :clips, dependent: :delete_all
end
