class AddUserContentToClips < ActiveRecord::Migration
  def change
    add_column :clips, :user_content, :boolean, default: false
  end
end
