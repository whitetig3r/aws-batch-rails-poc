require 'aws-sdk-batch'
require 'yaml'
require 'json'

module BatchJobSubmitter
  class BatchJobSubmitter

    SCRIPT_JOB_MAP = {
        LOGGER: 'api_logger.rb'
    }

    def info?
      'A Submission Handler which works by placing jobs on an AWS Batch Job Queue'
    end

    def initialize
      @credentials = YAML.load(
        ERB.new(
          File.read(
              File.expand_path('../../../config/aws.yml',
                               File.dirname(
                                   __FILE__
                               ))
          )
        ).result)['development']
    end

    def self.instance
      @instance ||= new
    end

    def batch_client
      @client ||= Aws::Batch::Client.new(region: @credentials['region'],
                                         credentials: Aws::Credentials.new(@credentials['access_key_id'],
                                            @credentials['secret_access_key']))
    end

    def map_execution_script(script_action)
      SCRIPT_JOB_MAP[script_action]
    end

    def submit_batch_job(script_action, param_hash)
      mapped_execution_script = map_execution_script script_action

      batch_client.submit_job(
                                  job_definition: 'generic-batch-job:1',
                                  job_name: 'api-batch-job',
                                  job_queue: 'samabatch-job-queue',
                                  parameters: {
                                      'jobScript' => mapped_execution_script,
                                      'params' => param_hash.to_json
                                  }
                              )
    end

  end

end
