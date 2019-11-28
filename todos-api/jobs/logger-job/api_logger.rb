require 'tempfile'
require_relative 's3_client.rb'

class ApiLogger

  def put_log(local_path, s3_path, content_type)
    s3_client.upload_file(local_path, s3_path, content_type)
  end

  def write_log(req_method)
    name = self.class.name.upcase
    s3_path = File.join('batch_test', name, 'API_REQUEST.log')
    file = Tempfile.new(name)

    begin
      file.write <<~FILE
        A REQUEST WAS MADE TO THE API @ #{Time.now.strftime('%d/%m/%Y %H:%M')} for action - #{req_method}
      FILE
      put_log(file, s3_path, 'text/plain')
    ensure
      file.close
      file.unlink
    end
  end

  def s3_client
    S3Client.instance
  end
end

api_logger = ApiLogger.new
api_logger.write_log(ARGV[0]) # contains the request method