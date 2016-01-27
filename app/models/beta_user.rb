class BetaUser < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :music_backgrounds

  enum phone_types: {
      iPhone: 0,
      Android: 1
  }
  enum music_background: {
      music_fan: 0,
      produce_music: 1,
      play_instrument: 2,
      pro_dj: 3,
      own_audio_software: 4,
      pro_musician_producer: 5,
      dj: 6,
      pro_audio_engineer: 7
  }

  default_values phone_type: BetaUser.phone_types[:iPhone]

  validates :name, presence: true
	validates :email, presence: true, email: true
	validates :phone_type, presence: true
  validates :age, numericality: { greater_than: 0, less_than: 101}
end
