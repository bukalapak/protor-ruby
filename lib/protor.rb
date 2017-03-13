require 'monitor'

require_relative 'protor/udp_formatter'
require_relative 'protor/udp_client'
require_relative 'protor/logger_client'
require_relative 'protor/registry'
require_relative 'protor/version'

class Protor
  include MonitorMixin

  DEFAULT_CONFIG = {
    client: :udp,
    formatter: :udp,
    host: 'localhost',
    port: 10601,
    packet_size: 56_607
  }

  attr_reader :config, :registry

  def initialize(&block)
    super(&block)

    @config = DEFAULT_CONFIG.dup
    @registry = Registry.new
    yield(config) if block_given?
  end

  def publish
    safely do
      client.publish(registry)
      registry.reset
    end
    logger.debug("publish") if logger
  end

  [:counter, :gauge, :histogram].each do |method|
    define_method method do |*args|
      safely{ registry.public_send(method, *args) }
      logger.debug("#{method} #{args}") if logger
    end
  end

  private

  def safely(&block)
    synchronize(&block)
  rescue StandardError => err
    logger.error(err) if logger
    raise err unless silent
  end

  def client
    @client ||=
      case config[:client]
      when :udp; UDPClient.new(config[:host], config[:port], formatter)
      when :logger; LoggerClient.new(logger, formatter)
      end
  end

  def formatter
    @formatter ||=
      case config[:formatter]
      when :udp; UDPFormatter.new(config[:packet_size])
      end
  end

  def logger
    config[:logger]
  end

  def silent
    config[:silent]
  end
end
