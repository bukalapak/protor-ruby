require 'protor/udp_formatter'
require 'protor/entry'

describe Protor::UDPFormatter do
  subject{ described_class.new(20) }

  it 'works' do
    line = ""
    data = [ Protor::Entry.new('aa', :c, 10.2, {a: 'a'}) ]
    subject.format(data) do |l|
      line << l
    end

    expect(line).to eql "aa|c|a=a|10.2\n"
  end

  it 'automatically split the packets' do
    data = [ Protor::Entry.new('aa', :c, 10.2, {a: 'a'}),
             Protor::Entry.new('bb', :c, 10.2, {a: 'a'})]

    expect{ |b| subject.format(data, &b) }.to yield_control.exactly(2).times
  end

  it 'with additional' do
    line = ""
    data = [ Protor::Entry.new('aa', :h, 10.2, {a: 'a', b: 'b'}, [1, 2, 3]) ]
    subject.format(data) do |l|
      line << l
    end

    expect(line).to eql "aa|h|1;2;3|a=a;b=b|10.2\n"
  end

  it 'with no labels' do
    line = ""
    data = [ Protor::Entry.new('aa', :g, 10.2) ]
    subject.format(data) do |l|
      line << l
    end

    expect(line).to eql "aa|g|10.2\n"
  end
end
