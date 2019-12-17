require 'tempfile'
require 'json'
require_relative "#{File.join(Dir.pwd, '/../utils/common_services.rb')}"

class ApiLogger < CommonServices
  def put_log(local_path, s3_path, content_type, job_name)
    write_cache(job_name, 'UPLOADING FILE')
    upload_to_s3(local_path, s3_path, content_type)
  end

  def write_log(job_name, req_method)
    name = self.class.name.upcase
    s3_path = File.join('batch_test', name, 'API_REQUEST.log')
    file = Tempfile.new(name)
    write_cache(job_name, 'WRITING TO FILE')
    begin
      file.write <<~FILE
        (#{job_name}) A REQUEST WAS MADE TO THE API @ #{Time.now.strftime('%d/%m/%Y %H:%M')} for action - #{req_method}
      FILE
      put_log(file, s3_path, 'text/plain', job_name)
    ensure
      file.close
      file.unlink
    end
    write_cache(job_name, 'COMPLETED')
  end
end

param_hash = JSON.parse ARGV[0] # contains the params for the job as a hash

api_logger = ApiLogger.new
api_logger.write_log(param_hash['job_name'], param_hash['request_action']) # contains the job_name & request method