class MixaudioBuildWorker
  include Sidekiq::Worker
  sidekiq_options retry: 10, queue: 'carrierwave'

  def perform(song_id)

    song = Song.find song_id
    song.build_mixaudio
  end
end