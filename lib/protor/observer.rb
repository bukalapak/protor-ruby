module Protor
  class Observer
    def initialize(type)
      @data = {}
      @type = type
    end

    def observe(metric_name, value, labels = {}, additional = [])
      data[metric_name] ||= { values: {} }
      data[metric_name][:values][labels] ||= []

      data[metric_name][:additional] = additional
      data[metric_name][:values][labels] << value
    end

    def to_a
      array = []

      data.each do |metric_name, values|
        first = true
        values[:values].each do |labels, value|
          value.each do |val|
            array << {
              metric_name: metric_name,
              labels: labels,
              value: val,
              additional: values[:additional],
              first: first,
              type: type
            }
            first = false
          end
        end
      end

      return array
    end

    def empty?
      data.empty?
    end

    private

    attr_reader :data, :type
  end
end
