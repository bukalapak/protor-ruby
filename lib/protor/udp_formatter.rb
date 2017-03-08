class Protor
  class UDPFormatter
    attr_reader :max_packet_size

    LF = "\n".freeze

    def initialize(max_packet_size)
      @max_packet_size = max_packet_size
    end

    def format(registry)
      return unless block_given?

      str = ""
      size = 0
      registry.each do |entry|
        line = stringify(entry)

        if size + line.size > max_packet_size
          yield(str)
          str = line
          size = line.size
        else
          str << line
          size += line.size
        end
      end
      yield(str)
    end

    private

    def stringify(entry)
      "#{ entry.name }|#{ entry.type }|".tap do |str|
        str << "#{ additional_string(entry.additional) }|" unless entry.additional.empty?
        str << "#{ labels_string(entry.labels) }|" unless entry.labels.empty?
        str << "#{ entry.value }#{LF}"
      end
    end

    def labels_string(labels)
      labels.map{ |k, v| "#{k}=#{v}" }.join(';')
    end

    def additional_string(additional)
      additional.join(';')
    end
  end
end

