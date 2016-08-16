require 'protor/observer'

describe Protor::Observer do
  subject{ described_class.new 'observer' }

  describe '#observe' do
    it 'save observed value' do
      subject.observe('a', 1)

      expect(subject.to_a).to eql [{ metric_name: 'a', additional: [], labels: {}, value: 1, type: 'observer', first: true }]
    end

    it 'first metric should have "first"' do
      subject.observe('a', 1)
      subject.observe('a', 1)
      subject.observe('b', 1)

      expect(subject.to_a).to eql [
        { metric_name: 'a', labels: {}, value: 1, additional: [], type: 'observer', first: true },
        { metric_name: 'a', labels: {}, value: 1, additional: [], type: 'observer', first: false },
        { metric_name: 'b', labels: {}, value: 1, additional: [], type: 'observer', first: true }
      ]
    end
  end

  describe '#empty?' do
    it{ is_expected.to be_empty }
    it{ subject.observe('a', 1); is_expected.not_to be_empty }
  end

  describe '#to_a' do
    it { expect(subject.to_a).to eql [] }
  end
end
