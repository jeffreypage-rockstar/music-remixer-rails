class ClipType < ActiveRecord::Base
	# default_scope { order('row') }
	
	belongs_to :song

  def self.row_name(row=nil)
    clipTypeNames = %w(Lead Bass Drums Instruments Rmx1 Rmx2 Rmx3 Rmx4)
    clipTypeNames[row - 1]
  end
end
