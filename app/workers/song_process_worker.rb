class SongProcessWorker < ::CarrierWave::Workers::StoreAsset
  def perform(*args)
    super(*args)

    song = constantized_resource.find id
    if song.clips.where.not(storing_status, Clip.storing_statuses[:storing_done]).count == 0
      song.update_attribute(:processing_status, :processing_done)
    end
  end

  sidekiq_retries_exhausted do
    song = constantized_resource.find id
    song.update_attribute(:processing_status, :processing_failed)
  end
end