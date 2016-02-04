class MixaudioBuildWorker
  include Sidekiq::Worker
  sidekiq_options retry: 10, queue: 'carrierwave'

  def perform(song_id)
    song = Song.find song_id
    Rails.logger.info "MixaudioBuildWorker: calling build_mixaudio for song #{song_id}"
    song.build_mixaudio
    song.build_mixaudio 'mix2'
    song.build_mixaudio 'mix3'
    Rails.logger.info "MixaudioBuildWorker: done with build_mixaudio for song #{song_id}"
    if song.processing_for_release?
      song.status = Song.statuses[:released]
      song.save
      User.increment_counter(:songs_count, song.user_id)
      Rails.logger.info "MixaudioBuildWorker: set status to 'released' for song #{song_id}"
    end
  end
end