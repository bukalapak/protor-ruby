require 'protor/entry_family'

describe Protor::EntryFamily do
  subject{ described_class.new(:test_metric, :c) }

  describe '#[]=' do
    it{ expect{ subject[ test: 'wow' ] = 1 }.to change{ subject.data.size }.from(0).to(1) }
  end

  describe '#[]' do
    it{ expect{ subject[ a: 'a', b: 'b' ] = 100 }.to change{ subject[b: 'b', a: 'a'] }.from(nil).to(100) }
  end

  describe '#each' do
    it do
      subject[:a] = 1
      subject[:b] = 2
      count = 0

      expect{ subject.each{ |_| count += 1 } }.to change{ count }.from(0).to(2)
    end
  end
end
