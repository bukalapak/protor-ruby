require 'protor/entry'

describe Protor::Entry do
  let(:name)       { :test_metric }
  let(:type)       { :c }
  let(:value)      { 100.1 }
  let(:labels)     { { wow_wow: 'wawaw-waw' } }
  let(:additional) { [ 1, 2, 3, 4.5 ] }

  context 'valid entry' do
    it{ expect{ described_class.new(name, type, value, labels, additional) }.not_to raise_error }
  end

  context 'invalid name' do
    let(:name) { "haha hihi" }
    it{ expect{ described_class.new(name, type, value, labels, additional) }.to raise_error(Protor::InvalidNameError) }
  end

  context 'invalid type' do
    let(:type) { :s }
    it{ expect{ described_class.new(name, type, value, labels, additional) }.to raise_error(Protor::InvalidTypeError) }
  end

  context 'invalid label name' do
    let(:labels) { { wow_wow: 'waw-waw', "wee ": 'weee' } }
    it{ expect{ described_class.new(name, type, value, labels, additional) }.to raise_error(Protor::InvalidLabelNameError) }
  end

  context 'invalid label value' do
    let(:labels) { { wow_wow: 'waw-waw', wee: 'weee=' } }
    it{ expect{ described_class.new(name, type, value, labels, additional) }.to raise_error(Protor::InvalidLabelValueError) }
  end

  context 'invalid additional' do
    let(:additional) { [ 1, 2, 3, "4.5" ] }
    it{ expect{ described_class.new(name, type, value, labels, additional) }.to raise_error(Protor::InvalidAdditionalError) }
  end
end
