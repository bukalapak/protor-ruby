require 'protor/accumulator'

describe Protor::Accumulator do
  subject{ described_class.new 'accumulator' }

  describe '#inc' do
    it 'accumulate value' do
      subject.inc('a', 1)
      subject.inc('a', 3)

      expect(subject.to_a).to eql [{ metric_name: 'a', labels: {}, value: 4, type: 'accumulator' }]
    end
  end

  describe '#set' do
    it 'replace old value' do
      subject.inc('a', 1)
      subject.set('a', 3)

      expect(subject.to_a).to eql [{ metric_name: 'a', labels: {}, value: 3, type: 'accumulator' }]
    end
  end

  describe '#empty?' do
    it{ is_expected.to be_empty }
    it{ subject.inc('a', 1); is_expected.not_to be_empty }
  end

  describe '#to_a' do
    it { expect(subject.to_a).to eql [] }
  end
end
