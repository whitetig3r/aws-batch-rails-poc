module ReadCache
  class << self
    def redis
      @url = YAML.load(
              ERB.new(
                  File.read(
                      File.expand_path('../redis_creds.yml',
                                       File.dirname(
                                           __FILE__
                                       ))
                  )
              ).result)['development']
      @redis ||= Redis.new(:url => @url['url'])
    end
  end
end