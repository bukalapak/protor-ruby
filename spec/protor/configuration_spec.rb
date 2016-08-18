require 'protor/configuration'

describe Protor::Configuration do
  describe 'default value' do
    it{ expect(subject.host).to eql 'localhost' }
    it{ expect(subject.port).to eql 10601 }
    it{ expect(subject.max_packet_size).to eql 56_607 }
  end
end
