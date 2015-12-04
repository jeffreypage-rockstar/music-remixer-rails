class Referral < ActiveRecord::Base
  belongs_to :referring, class_name: 'User'
  belongs_to :referred, class_name: 'User'

  attr_accessor :emails

  default_value_for :invite_code do
    SecureRandom.hex(5)
  end

  scope :virgin, -> { where(referred_id: nil, signed_up_at: nil) }

  validates :emails, presence: true, if: Proc.new { |r| r.email.blank? }
end
