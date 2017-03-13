require_relative 'entry'
require_relative 'entry_family'

class Protor
  class Registry
    attr_reader :families

    DEFAULT_BUCKET = [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10].freeze

    def initialize
      @families = {}
    end

    def counter(metric_name, value, labels = {})
      labels = stringify(labels)
      fam = family(metric_name, :counter)

      if (entry = fam[labels])
        entry.value += value
      else
        fam[labels] = Entry.new(metric_name, :c, value, labels)
      end
    end

    def gauge(metric_name, value, labels = {})
      labels = stringify(labels)
      fam = family(metric_name, :gauge)

      if (entry = fam[labels])
        entry.value = value
      else
        fam[labels] = Entry.new(metric_name, :g, value, labels)
      end
    end

    def histogram(metric_name, value, labels = {}, buckets = DEFAULT_BUCKET)
      labels = stringify(labels)
      fam = family(metric_name, :histogram)

      entry = Entry.new(metric_name, :h, value, labels, buckets)
      if (array = fam[labels])
        array << entry
      else
        fam[labels] = [ entry ]
      end
    end

    def each
      families.each_value do |family|
        if family.type == :histogram
          family.each{ |arr| arr.each{ |e| yield(e) }}
        else
          family.each{ |e| yield(e) }
        end
      end
    end

    def reset
      @families = {}
    end

    def empty?
      families.empty?
    end

    private

    def stringify(labels)
      {}.tap do |h|
        labels.each do |k, v|
          val = v.to_s
          h[k.to_s] = val unless val.empty?
        end
      end
    end

    def family(name, type)
      families[name] ||= EntryFamily.new(name, type)
      family = families[name]
      raise IncompatibleTypeError.new(name, family.type, type) if family.type != type

      return family
    end
  end

  class IncompatibleTypeError < StandardError
    def initialize(name, previous, now)
      super("Incompatible type for metric #{name}, previously it was a #{previous}, now it is a #{now}")
    end
  end
end
