if Rails.env.test? || Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
    config.asset_host = 'http://localhost:3000'
  end
elsif Rails.env.production?
  CarrierWave.configure do |config|
    config.cache_dir = "#{Rails.root}/tmp/uploads"

    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['BMWL_AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['BMWL_AWS_SECRET_ACCESS_KEY'],
      region:                'us-east-1'
    }
    config.fog_directory  = ENV['BMWL_AWS_DIRECTORY']                     # required
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  end
end
