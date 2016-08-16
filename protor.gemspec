# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'protor/version'

Gem::Specification.new do |s|
  s.name              = 'protor'
  s.version           = Protor::VERSION
  s.summary           = 'Prometheus aggregator client for ruby.'
  s.authors           = ['Roland Rinfandi Utama']
  s.email             = ['roland_hawk@yahoo.com']
  s.homepage          = 'https://github.com/rolandhawk/protor-ruby'
  s.license           = 'MIT'

  s.files             = %w(README.md) + Dir.glob('{lib/**/*}')
  s.require_paths     = ['lib']
end
