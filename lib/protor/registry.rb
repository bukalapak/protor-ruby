require_relative 'payload'
require_relative 'accumulator'
require_relative 'observer'

module Protor
  class Registry
    HistogramDefaultBuckets = [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10].freeze

    def initialize(options)
      @options = options
    end

    def counter(metric_name, value, labels = {})
      counter_data.inc(metric_name, value, labels)
    end

    def gauge(metric_name, value, labels = {})
      gauge_data.set(metric_name, value, labels)
    end

    def histogram(metric_name, value, labels = {}, buckets = HistogramDefaultBuckets)
      histogram_data.observe(metric_name, value, labels, buckets)
    end

    def each
      payload = Payload.new options.max_packet_size
      all_data.each do |data|
        unless payload.add(data)
          yield payload.to_s

          payload = Payload.new options.max_packet_size
          payload.add(data)
        end
      end

      yield payload.to_s
    end

    def empty?
      [@counter, @gauge, @histogram].all?{ |metrics| metrics && metrics.empty? }
    end

    private

    attr_reader :options

    def counter_data
      @counter ||= Accumulator.new(:counter)
    end

    def gauge_data
      @gauge ||= Accumulator.new(:gauge)
    end

    def histogram_data
      @histogram ||= Observer.new(:histogram)
    end

    def all_data
      [counter_data.to_a, gauge_data.to_a, histogram_data.to_a].flatten
    end
  end
end
