require_relative './s3_client.rb'
require_relative './redis.rb'

class CommonServices
  def write_cache(key, val)
    ReadCache.redis.set key, val
  end

  def read_cache(key)
    ReadCache.redis.get key
  end

  def s3_client
    S3Client.instance
  end

  def upload_to_s3(local_path, s3_path, content_type)
    s3_client.upload_file local_path, s3_path, content_type
  end
end