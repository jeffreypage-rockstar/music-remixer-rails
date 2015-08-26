class Clip < ActiveRecord::Base
	belongs_to :song
	scope :exist, ->(row, column) { where(row: row, column: column) }
end
