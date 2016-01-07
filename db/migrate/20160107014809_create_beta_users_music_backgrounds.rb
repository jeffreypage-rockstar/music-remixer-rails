class CreateBetaUsersMusicBackgrounds < ActiveRecord::Migration
  def change
    create_table :beta_users_music_backgrounds do |t|
      t.belongs_to :beta_user, index: true
      t.belongs_to :music_background, index: true
    end
  end
end
