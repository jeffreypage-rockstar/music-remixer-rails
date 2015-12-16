class Remix < ActiveRecord::Base
	mount_uploader :audio, RemixAudioUploader
	store_in_background :audio, SongProcessWorker

	enum status: {processing: 0, failed: 1, published: 2}

	belongs_to :user, counter_cache: true
	belongs_to :song
end
