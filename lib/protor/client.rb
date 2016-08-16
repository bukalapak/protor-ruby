require 'socket'

module Protor
  class Client
    def initialize(configuration)
      @options = configuration
    end

    def publish(payload)
      established do |connection|
        payload.each{ |str| connection.send(str, 0) }
      end
    end

    private

    attr_reader :options

    def established
      socket = UDPSocket.new
      socket.connect(options.host, options.port)
      yield socket
    rescue Errno::ECONNREFUSED => exception
      # omit error, it caused by aggregate server being down
      exception
    ensure
      socket.close unless socket.closed?
    end
  end
end
