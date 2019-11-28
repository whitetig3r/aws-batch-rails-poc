require 'aws-sdk-batch'
require 'yaml'

module BatchJobLogger
  class BatchJobLogger

    def info?
      'A Logger which works by placing jobs on a AWS Batch Job Queue'
    end

    def initialize
      @credentials = YAML.load(
        ERB.new(
          File.read(
            File.expand_path(File.dirname(__FILE__)) + '/../../../config/aws.yml')
        ).result)['development']
    end

    def self.instance
      @instance ||= new
    end

    def batch_client
      @client ||= Aws::Batch::Client.new(region: @credentials['region'],
                                         credentials: Aws::Credentials.new(@credentials['access_key_id'],
                                            @credentials['secret_access_key'])
                                        )
    end

    def map_request_action(request_action)
      case request_action
      when 'index', 'show'
        'GET'
      when 'create'
        'POST'
      when 'update'
        'PUT'
      when 'destroy'
        'DELETE'
      else
        'BAD_METHOD'
      end
    end

    def submit_batch_job(request_action)
      mapped_request_action = map_request_action request_action
      batch_client.submit_job(
                                  job_definition: 'logger-job-PoC:2',
                                  job_name: 'api-logger-job',
                                  job_queue: 'samabatch-job-queue',
                                  parameters: {
                                      'requestAction' => mapped_request_action
                                  }
                              )
    end

  end

end
