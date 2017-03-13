require 'protor/registry'

describe Protor::Registry do
  subject{ described_class.new }

  it 'save all metric' do
    subject.counter('aa', 1, a: 'a')
    subject.counter('aa', 2, a: 'b')
    subject.counter('aa', 2, a: 'b')
    subject.gauge('bb', 1)
    subject.gauge('bb', 2)
    subject.histogram('cc', 1, a: 'a')
    subject.histogram('cc', 2, a: 'b')
    subject.histogram('cc', 2, a: 'b')

    is_expected.not_to be_empty
    expect{ |b| subject.each(&b) }.to yield_control.exactly(6).times
  end

  it 'error for inconsistent metric type' do
    subject.counter('aa', 1)
    expect{ subject.gauge('aa', 1) }.to raise_error(Protor::IncompatibleTypeError)
  end

  it 'dont yield anything' do
    expect{ |b| subject.each(&b) }.not_to yield_control
  end

  it 'discard nil value' do
    expect{ subject.counter('aa', 1, a: nil) }.not_to raise_error
  end

  it 'can be resetted' do
    subject.counter('aa', 1, a: 'a')
    subject.reset

    is_expected.to be_empty
  end
end
