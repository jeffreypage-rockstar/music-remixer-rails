class SongProcessWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    super(*args)

    song = constantized_resource.find id
    logger.info "SongProcessWorker starting job on Song: #{song.inspect}"

    if song.clips.where.not(storing_status: Clip.storing_statuses[:storing_done]).count == 0
      logger.info "SongProcessWorker all clips have been processed on Song: #{song.id}"
      if song.processed?
        song.update_attribute(:status, :released)
        logger.info "SongProcessWorker setting song status to released for Song: #{song.id}"
      end
    end
  end

  sidekiq_retries_exhausted do
    song = constantized_resource.find id
    song.update_attribute(:status, :failed)
  end
end