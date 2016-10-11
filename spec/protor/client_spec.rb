require 'protor/client'

config = Object.new
def config.host; 'localhost'; end;
def config.port; 10602; end;
def config.logger; Logger.new(File::NULL) ; end;

describe Protor::Client do
  subject{ described_class.new(config) }

  it 'do not raise any error' do
    expect{ subject.publish(["a","a"]) }.not_to raise_error
  end
end
