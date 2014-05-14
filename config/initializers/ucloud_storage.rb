UcloudStorage.configure do |config|
  config.user = ENV['UCLOUD_ID']
  config.pass = ENV['UCLOUD_SECRET']
end