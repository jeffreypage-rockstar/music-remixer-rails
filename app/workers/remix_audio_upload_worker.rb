class RemixAudioUploadWorker < ::CarrierWave::Workers::StoreAsset
  sidekiq_options retry: 10

  def perform(*args)
    super(*args)

    remix = constantized_resource.find id
    remix.update_attribute(:status, :published)
    User.increment_counter(:remixes_count, remix.user_id)
  end

  sidekiq_retries_exhausted do
    remix = constantized_resource.find id
    remix.update_attribute(:status, :failed)
  end
end