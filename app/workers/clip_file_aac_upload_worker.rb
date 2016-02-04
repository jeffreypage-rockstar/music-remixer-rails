class ClipFileAacUploadWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    super(*args)

    clip = constantized_resource.find id
    logger.info "ClipFileAacUploadWorker starting job on Clip: #{clip.inspect}"

    unless clip.file_tmp
      clip.update_attribute(:storing_status, :storing_done)
    end

    part = clip.part

    if part.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      part.update_attribute(:duration, part.clips.average(:duration))
    end

    if clip.song.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      # all clips are done processing, set status to working
      clip.song.update_attribute(:status, :working)
    end

    logger.info "ClipFileAacUploadWorker ended job on Clip: #{clip.inspect}"
  end

  sidekiq_retries_exhausted do
    clip = constantized_resource.find id
    clip.update_attribute(:storing_status, :storing_failed)
    clip.song.update_attribute(:status, :failed)
  end
end