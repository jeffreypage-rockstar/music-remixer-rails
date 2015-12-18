class ChangeDurationForParts < ActiveRecord::Migration
  def change
    change_column :parts, :duration, :float
  end
end
