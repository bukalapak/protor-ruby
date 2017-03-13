require 'protor'

describe Protor do
  subject{ described_class.new }

  context 'normal usage' do
    subject{ described_class.new }

    it do
      expect(subject.registry).to receive(:reset)
      expect do
        subject.histogram('aaa', 1)
        subject.counter('bbb', 1)
        subject.gauge('ccc', 1)

        subject.publish
      end.not_to raise_error
    end
  end

  context 'error' do
    subject do
      described_class.new do |conf|
        conf[:packet_size] = 10
      end
    end

    it do
      expect do
        subject.histogram('aaa', 1)
        subject.counter('bbb', 1)
        subject.gauge('ccc', 1)

        subject.publish
      end.to raise_error(Errno::ECONNREFUSED)
    end
  end

  context 'silent error' do
    subject do
      described_class.new do |conf|
        conf[:packet_size] = 10
        conf[:silent] = true
      end
    end

    it do
      expect do
        subject.histogram('aaa', 1)
        subject.counter('bbb', 1)
        subject.gauge('ccc', 1)

        subject.publish
      end.not_to raise_error
    end
  end

  context 'can use logger too' do
    subject do
      described_class.new do |conf|
        conf[:client] = :logger
        conf[:logger] = fake_logger
      end
    end
    let(:fake_logger) do
      Class.new do
        def initialize; @count = 0; end;
        def debug(*); @count += 1; end;
        def info(*); @count += 1; end;
        def count; @count; end;
      end.new
    end

    it do
      expect do
        subject.histogram('aaa', 1)
        subject.counter('bbb', 1)
        subject.gauge('ccc', 1)

        subject.publish
      end.not_to raise_error
    end
  end
end
