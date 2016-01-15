class SongProcessWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    super(*args)

    song = constantized_resource.find id
    if song.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      #FileUtils.rm_r(song.song_tmp_directory_path, :force => true)
      song.update_attribute(:status, :released)
    end
  end

  sidekiq_retries_exhausted do
    song = constantized_resource.find id
    song.update_attribute(:status, :failed)
  end
end