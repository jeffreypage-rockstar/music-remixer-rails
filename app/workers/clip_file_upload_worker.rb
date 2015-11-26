class ClipFileUploadWorker < ::CarrierWave::Workers::StoreAsset
  def perform(*args)
    super(*args)

    clip = constantized_resource.find id
    clip.update_attribute(:storing_status, :processing_done)
    song = clip.song
    if !song.processing_done? && song.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      song.update_attribute(:processing_status, :processing_done)
    end
  end

  sidekiq_retries_exhausted do
    clip = constantized_resource.find id
    clip.update_attribute(:storing_status, :processing_failed)
    clip.song.update_attribute(:processing_status, :processing_failed)
  end
end