require 'protor/udp_client'

describe Protor::UDPClient do
  subject{ described_class.new(host, port, fake_formatter) }

  let(:msg){ ["test\n", "test"] }
  let(:host){ 'localhost' }
  let(:port){ 9090 }
  let(:fake_formatter) do
    Class.new do
      def format(data); data.each{ |d| yield(d) }; end;
    end.new
  end

  it 'works' do
    socket = UDPSocket.new
    socket.bind(host, port)

    subject.publish(msg)

    resp, _ = socket.recvfrom(5)
    expect(resp).to eql msg.first

    resp, _ = socket.recvfrom(4)
    expect(resp).to eql msg.last

    socket.close
  end

  it 'can be error' do
    expect{ subject.publish(msg) }.to raise_error(Errno::ECONNREFUSED)
  end
end
