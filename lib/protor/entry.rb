class Protor
  class Entry
    attr_reader :name, :type, :value, :labels, :additional
    attr_writer :value

    VALID_NAME        = /^[a-zA-Z_:][a-zA-Z0-9_:]+$/
    VALID_TYPE        = [:c, :g, :h]
    VALID_LABEL_NAME  = /^[a-zA-Z_][a-zA-Z0-9_]*$/
    VALID_LABEL_VALUE = /^[^;|=]+$/

    def initialize(name, type, value, labels = nil, additional = nil)
      @name       = name.to_s
      @type       = type
      @value      = value
      @labels     = labels || {}
      @additional = additional || []

      verify
    end

    private

    def verify
      raise InvalidNameError, name unless name =~ VALID_NAME
      raise InvalidTypeError, type unless VALID_TYPE.include?(type)
      labels.each do |k, v|
        raise InvalidLabelNameError, labels unless k =~ VALID_LABEL_NAME
        raise InvalidLabelValueError, labels unless v =~ VALID_LABEL_VALUE
      end
      additional.each do |a|
        raise InvalidAdditionalError, additional unless a.is_a?(Numeric)
      end
    end

  end

  class InvalidNameError < StandardError
    def initialize(message)
      super("Invalid name #{message}, please satisfy /^[a-zA-Z_:][a-zA-Z0-9_:]+$/")
    end
  end

  class InvalidTypeError < StandardError
    def initialize(message)
      super("Invalid type #{message}, allowed types are [c, g, h]")
    end
  end

  class InvalidLabelNameError < StandardError
    def initialize(message)
      super("Invalid label name #{message}, please satisfy /^[a-zA-Z_][a-zA-Z0-9_]*$/")
    end
  end

  class InvalidLabelValueError < StandardError
    def initialize(message)
      super("Invalid label value #{message}, please satisfy /^[^;|=\s]+$/")
    end
  end

  class InvalidAdditionalError < StandardError
    def initialize(message)
      super("Invalid additional {message}, additional must be numbers")
    end
  end
end
