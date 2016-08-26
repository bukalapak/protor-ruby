require 'monitor'

require_relative 'protor/configuration'
require_relative 'protor/client'
require_relative 'protor/registry'
require_relative 'protor/version'

module Protor
  extend MonitorMixin
end

class << Protor
  def configuration
    @configuration ||= Protor::Configuration.new
  end

  def configure
    yield(configuration)
  end

  def publish
    synchronize do
      unless registry.empty?
        client.publish(registry)
        reset
      end
    end
  end

  [:counter, :gauge, :histogram].each do |method|
    define_method method do |*args, &block|
      synchronize{ registry.public_send(method, *args, &block) }
    end
  end

  private

  def client
    @client ||= Protor::Client.new(configuration)
  end

  def registry
    @registry || reset
  end

  def reset
    @registry = Protor::Registry.new(configuration)
  end
end
