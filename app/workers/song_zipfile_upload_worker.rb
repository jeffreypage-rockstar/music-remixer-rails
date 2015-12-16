class SongZipfileUploadWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    set_args(*args)
    song = constantized_resource.find id
    song.extract_zipfile!
    song.build_parts_and_clips
    song.build_mixaudio

    super(*args)
  end

  sidekiq_retries_exhausted do
    song = constantized_resource.find id
    song.update_attribute(:status, :failed)
  end
end