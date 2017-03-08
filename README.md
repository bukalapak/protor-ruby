# protor-ruby
[Prometheus aggregator](https://github.com/rolandhawk/prometheus-aggregator) client for ruby

## Installation
In Gemfile
````ruby
gem 'protor'
````
Then run
````shell
bundle install
````

## Usage
### Counter
It automatically aggregate value

````ruby
protor.counter(:counter, 1, {label1: 1}) # value => 1
protor.counter(:counter, 1, {label1: 1}) # value => 2
````
### Gauge
It automatically replace value
````ruby
protor.gauge(:gauge, 50) # value 50
protor.gauge(:gauge, 20) # value 20
````

### Histogram
It save all observed values
````ruby
protor.histogram(:histogram, 10, {label1: 1}, [1,2,3,4]) # observed value [10]
protor.histogram(:histogram, 2, {label1: 1}, [1,2,3,4](  # observed value [10,2]
````

### Publish
To publish all saved metrics to aggregator
````ruby
protor.publish
````

## Configuration
To configure protor:
````ruby
$protor = Protor.new do |conf|
  conf[:client] = :udp # valid option :udp and :logger, use :logger to print into a Logger
  conf[:host] = 'localhost' # prometheus_aggregator host
  conf[:port] = 10601 # prometheus_aggregator port
  conf[:logger] = Rails.logger # logger to be used by protor
  conf[:packet_size] = 56_607 # max udp packet buffer
  conf[:formatter] = :udp # valid option only :udp, format to send
end
````

## Contributing
[Fork the project](https://github.com/rolandhawk/protor-ruby) and send pull requests.
