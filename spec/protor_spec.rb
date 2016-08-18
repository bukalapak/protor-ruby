require 'protor'

describe Protor do
  subject{ described_class }

  it 'must work' do
    expect do
      subject.histogram('aaa', 1)
      subject.counter('bbb', 1)
      subject.gauge('ccc', 1)

      subject.publish
    end.not_to raise_error
  end

  it 'have configuration' do
    expect(subject.configuration).not_to be_nil
  end

  it 'configurable' do
    expect do
      subject.configure{ |config| config.host = 'http://test.test.test' }
    end.not_to raise_error
  end
end
