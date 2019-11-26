require 'yaml'
require 'aws-sdk-s3'
require 'erb'

class S3Client
  def initialize
    @credentials = YAML.load(
        ERB.new(
            File.read(
                File.expand_path(File.dirname(__FILE__)) + '/aws.yml')
          ).result)['development']
  end

  def self.instance
    @instance ||= self.new
  end

  def bucket
    @credentials['bucket']
  end

  def client
    @client ||= Aws::S3::Client.new(
        region: @credentials['region'],
        credentials: Aws::Credentials.new(@credentials['access_key_id'],
                                          @credentials['secret_access_key'])
      )
  end

  def s3_resource
    @s3_resource ||= Aws::S3::Resource.new(
        region: @credentials['region'],
        credentials: Aws::Credentials.new(@credentials['access_key_id'],
                                          @credentials['secret_access_key'])
      )
  end

  def upload_file(path, s3_path, content_type)
    object = s3_resource.bucket(bucket).object(s3_path)
    object.upload_file(
        path,
        content_disposition: 'attachment',
        content_type: content_type
      )
    url_path(object)
  end

  def self.url_path(obj)
    instance.url_path(obj)
  end

  def url_path(obj)
    obj.presigned_url(:get,
                      expires_in: 3600,
                      response_content_disposition: 'ResponseContentDisposition'
                     )
  end

end