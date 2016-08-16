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
Protor.counter(:counter, 1, {label1: 1}) # value => 1
Protor.counter(:counter, 1, {label1: 1}) # value => 2
````
### Gauge
It automatically replace value
````ruby
Protor.gauge(:gauge, 50) # value 50
Protor.gauge(:gauge, 20) # value 20
````

### Histogram
It save all observed values
````ruby
Protor.histogram(:histogram, 10, {label1: 1}, [1,2,3,4]) # observed value [10]
Protor.histogram(:histogram, 2, {label1: 1}, [1,2,3,4](  # observed value [10,2]
````

### Publish
To publish all saved metrics to aggregator
````ruby
Protor.publish
````

## Configuration
To configure protor:
````ruby
Protor.configure do |config|
  config.host = 'localhost'      # aggregator host, default to localhost
  config.port = 10601            # aggregator port, default to 10601
  config.max_packet_size = 56607 # max udp packet buffer, default to 56607
end
````

## Contributing
[Fork the project](https://github.com/rolandhawk/protor-ruby) and send pull requests.
