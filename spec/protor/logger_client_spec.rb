require 'protor/logger_client'

describe Protor::LoggerClient do
  subject{ described_class.new(fake_logger, fake_formatter) }
  let(:msg){ ["test\n", "test"] }

  let(:fake_formatter) do
    Class.new do
      def format(data); data.each{ |d| yield(d) }; end;
    end.new
  end

  let(:fake_logger) do
    Class.new do
      def initialize; @count = 0; end;
      def info(*); @count += 1; end;
      def count; @count; end;
    end.new
  end

  it 'works' do
    subject.publish(msg)
    expect(fake_logger.count).to eql 2
  end
end
