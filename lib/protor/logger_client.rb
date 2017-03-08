class Protor
  class LoggerClient
    attr_reader :logger, :formatter

    def initialize(logger, formatter)
      @logger = logger
      @formatter = formatter
    end

    def publish(payload)
      formatter.format(payload) do |msg|
        logger.info(msg)
      end
    end
  end
end
