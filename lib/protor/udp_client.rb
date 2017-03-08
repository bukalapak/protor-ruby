require 'socket'

class Protor
  class UDPClient
    attr_reader :host, :port, :formatter, :connection

    def initialize(host, port, formatter)
      @port = port
      @host = host
      @formatter = formatter
    end

    def publish(payload)
      connect do |conn|
        formatter.format(payload) do |msg|
          conn.send(msg, 0)
        end
      end
    end

    private

    def connect
      connection = UDPSocket.new
      connection.connect(host, port)
      yield(connection)
    ensure
      connection.close unless connection.closed?
    end
  end
end
