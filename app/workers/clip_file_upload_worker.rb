class ClipFileUploadWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    super(*args)

    clip = constantized_resource.find id
    clip.update_attribute(:storing_status, :storing_done)
    song = clip.song
    part = clip.part

    if part.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      part.update_attribute(:duration, part.clips.average(:duration))
    end

    if song.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      song.build_mixaudio
    end
  end

  sidekiq_retries_exhausted do
    clip = constantized_resource.find id
    clip.update_attribute(:storing_status, :storing_failed)
    clip.song.update_attribute(:status, :failed)
  end
end