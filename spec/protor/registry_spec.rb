require 'protor/registry'

config = Object.new
def config.max_packet_size; 10; end;

describe Protor::Registry do
  subject{ described_class.new(config) }

  it 'save all metric' do
    subject.counter('a', 1)
    subject.gauge('b', 1)
    subject.histogram('c', 1)

    is_expected.not_to be_empty
    expect{ |b| subject.each(&b) }.to yield_control
  end
end
