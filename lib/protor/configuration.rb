require 'logger'

module Protor
  class Configuration
    attr_writer :host, :port, :max_packet_size, :logger

    def host
      @host ||= 'localhost'
    end

    def port
      @port ||= 10601
    end

    def max_packet_size
      @max_packet_size ||= 56_607
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
