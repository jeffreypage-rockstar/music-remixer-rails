class SongZipfileUploadWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    set_args(*args)
    # do some stuff first
    song = constantized_resource.find id
    song.extract_zipfile!
    song.build_parts_and_clips
    # now have part class do the upload
    super(*args)
  end

  sidekiq_retries_exhausted do
    logger.error "SongZipfileUploadWorker sidekiq_retries_exhausted for song #{id}, setting status to failed"
    song = constantized_resource.find id
    song.update_attribute(:status, :failed)
  end
end