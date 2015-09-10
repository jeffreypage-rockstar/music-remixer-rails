class Part < ActiveRecord::Base
	default_scope { order('column') }
	validates :name, presence: true, length: { maximum: 10 }

	belongs_to :song
	has_many :clips, dependent: :delete_all
end
