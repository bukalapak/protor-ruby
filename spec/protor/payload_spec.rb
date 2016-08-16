require 'protor/payload'

describe Protor::Payload do
  subject{ described_class.new( 50_000 ) }

  describe 'simple' do
    let(:metric){ { metric_name: 'a', labels: {}, value: 1, type: 'accumulator' } }

    it 'works' do
      subject.add(metric)

      expect(subject.to_s).to eql "a|a|1\n"
    end
  end

  describe 'additional' do
    let(:metric1){ { metric_name: 'a', additional: [1,2,3], labels: {}, value: 1, type: 'observer', first: true } }
    let(:metric2){ { metric_name: 'a', additional: [1,2,3], labels: {}, value: 1, type: 'observer', first: false } }

    it 'have additional for first metric' do
      subject.add(metric1)

      expect(subject.to_s).to eql "a|o|1;2;3|1\n"
    end

    it 'automatically convert first metric to first true' do
      subject.add(metric2)

      expect(subject.to_s).to eql "a|o|1;2;3|1\n"
    end

    it 'do not have additional for non first metric' do
      subject.add(metric1)
      subject.add(metric2)

      expect(subject.to_s).to eql "a|o|1;2;3|1\na|o|1\n"
    end
  end

  describe 'common labels' do
    let(:metric1) { { metric_name: 'a', labels: { a: 'a', b: 'b' }, value: 1, type: 'a' } }
    let(:metric2) { { metric_name: 'a', labels: { a: 'a', c: 'c' }, value: 1, type: 'a' } }
    let(:metric3) { { metric_name: 'a', labels: { d: 'd', c: 'c' }, value: 1, type: 'a' } }

    it 'is all of metric label if only have 1 metric' do
      subject.add(metric1)

      expect(subject.to_s).to eql "a=a;b=b\na|a|1\n"
    end

    it 'is intersection of all metric labels' do
      subject.add(metric1)
      subject.add(metric2)

      expect(subject.to_s).to eql "a=a\na|a|b=b|1\na|a|c=c|1\n"
    end

    it 'is empty if no common metrics label' do
      subject.add(metric1)
      subject.add(metric3)

      expect(subject.to_s).to eql "a|a|a=a;b=b|1\na|a|d=d;c=c|1\n"
    end
  end

end
