module Protor
  class Accumulator
    def initialize(type)
      @data = {}
      @type = type
    end

    def inc(metric_name, value, labels = {})
      data[metric_name] ||= Hash.new(0)
      data[metric_name][labels] += value
    end

    def set(metric_name, value, labels = {})
      data[metric_name] ||= Hash.new(0)
      data[metric_name][labels] = value
    end

    def to_a
      array = []

      data.each do |metric_name, values|
        values.each do |labels, value|
          array << { metric_name: metric_name, labels: labels, value: value, type: type }
        end
      end

      return array
    end

    def empty?
      data.empty?
    end

    private

    attr_reader :type, :data
  end
end
