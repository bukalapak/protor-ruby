require_relative 'protor/configuration'
require_relative 'protor/client'
require_relative 'protor/registry'
require_relative 'protor/version'

module Protor
end

class << Protor
  def configuration
    @configuration ||= Protor::Configuration.new
  end

  def configure
    yield(configuration)
  end

  def publish
    binding.pry
    client.publish(@registry) unless @registry.empty?
  end

  [:counter, :gauge, :histogram].each do |method|
    define_method method do |*args, &block|
      registry.public_send(method, *args, &block)
    end
  end

  private

  def client
    @client ||= Protor::Client.new(configuration)
  end

  def registry
    @registry ||= Protor::Registry.new(configuration)
  end
end
