class ClipFileUploadWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    super(*args)

    clip = constantized_resource.find id
    clip.update_attribute(:storing_status, :storing_done)
    song = clip.song
    if !song.processing_done? && song.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      song.update_attribute(:status, :pending)
    end
  end

  sidekiq_retries_exhausted do
    clip = constantized_resource.find id
    clip.update_attribute(:storing_status, :storing_failed)
    clip.song.update_attribute(:status, :failed)
  end
end