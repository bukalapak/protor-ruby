class Protor
  class EntryFamily
    attr_reader :name, :type, :data

    def initialize(name, type)
      @name = name
      @type = type
      @data = {}
    end

    def []=(label, value)
      data[label] = value
    end

    def [](label)
      data[label]
    end

    def each
      return unless block_given?

      data.each_value{ |d| yield(d) }
    end
  end
end
