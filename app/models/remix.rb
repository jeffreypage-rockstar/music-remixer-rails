class Remix < ActiveRecord::Base
	include PublicActivity::Common

	mount_uploader :audio, RemixAudioUploader
	store_in_background :audio, RemixAudioUploadWorker

	enum status: {processing: 0, failed: 1, published: 2, archived: 3, deleted: 4}

  default_value_for :uuid do  #important, needs to be in a block
    SecureRandom.hex(12)
  end

  belongs_to :user
	belongs_to :song

  # allow comments on remixes
  acts_as_commentable
end
