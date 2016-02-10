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
      song.create_activity :release, owner: song.artist
      song.user.update_attribute(:songs_count, song.user.released_songs.count)
      Rails.logger.info "MixaudioBuildWorker: set status to 'released' for song #{song_id}"
    end
  end
end