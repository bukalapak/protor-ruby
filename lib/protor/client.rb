require 'socket'

module Protor
  class Client
    def initialize(configuration)
      @options = configuration
      @retries = 0
    end

    def publish(payload)
      connect
      payload.each do |message|
        send(message)
      end
    rescue Errno::EPERM, Errno::ECONNREFUSED => e
      options.logger.error(e)
    ensure
      close
    end

    private

    attr_reader :options, :connection, :retries

    def send(message)
      connection.send(message, 0)
    rescue Errno::EPERM => exception
      retries += 1
      if retries <= 3
        refresh && retry
      else
        raise exception
      end
    end

    def connect
      @connection = UDPSocket.new
      @connection.connect(options.host, options.port)
    end

    def refresh
      close
      connect
    end

    def close
      connection.close unless connection.closed?
    end
  end
end
