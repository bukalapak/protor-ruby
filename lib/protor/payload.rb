module Protor
  class Payload

    Lf = "\n".freeze


    def initialize(max_packet_size)
      @max_packet_size = max_packet_size
      @lines = []
      @total_size = 0
    end

    def add(data)
      data = data.dup
      data[:first] = true if lines.empty?

      return false if packet_overflow?(data)

      self.common_labels = data[:labels]
      @total_size += data_size(data)
      @lines << data
    end

    def to_s
      str = first_line
      lines.each do |data|
        line = template(data)
        str << "#{line}#{Lf}"
      end

      return str
    end

    private

    attr_reader :common_labels, :lines, :total_size, :max_packet_size

    def data_size(data)
      size = 3
      [:metric_name, :value].each do |key|
        size += data[key].to_s.size
      end

      size += labels_string(data[:labels]).size + 1 if data[:labels]

      size += additional_string(data[:additional]).size + 1 if data[:first] && data[:additional]

      return size
    end

    def common_labels=(labels = {})
      @common_labels ||= labels.dup
      intersect(common_labels, labels)
      @common_labels.keep_if{ |k, v| labels.key? k }
    end

    def first_line
      if !common_labels || common_labels.empty?
        ""
      else
        "#{labels_string(common_labels)}#{Lf}"
      end
    end

    def template(data)
      labels = exclude_common(data[:labels])

      "#{ data[:metric_name] }|#{ data[:type][0] }|".tap do |str|
        str << "#{ additional_string(data[:additional]) }|" if data[:first] && data[:additional]
        str << "#{ labels_string(labels) }|" unless labels.empty?
        str << "#{ data[:value] }"
      end
    end

    def labels_string(labels)
      labels.map{ |k, v| "#{k}=#{v}" }.join(';')
    end

    def additional_string(additional)
      additional.join(';')
    end

    def intersect(a, b)
      a.keep_if{ |k, v| b.key? k }
    end

    def exclude_common(labels)
      labels.keep_if{ |k, v| !common_labels[k] }
    end

    def packet_overflow?(data)
      backup = common_labels && common_labels.dup || data[:labels]
      intersect(backup, data[:labels])
      size = data_size(data)

      total_size + size - (labels_string(backup).size * lines.size) > max_packet_size
    end
  end
end

