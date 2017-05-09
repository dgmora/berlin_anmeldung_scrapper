# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berlin_anmeldung_scrapper/version'

Gem::Specification.new do |spec|
  spec.name          = 'berlin_anmeldung_scrapper'
  spec.version       = BerlinAnmeldungScrapper::VERSION
  spec.authors       = ['David Garcia']
  spec.email         = ['david.garcia.mora@gmail.com']

  spec.summary       = 'Finds you suitable appointments to register as Berlin citzen'
  spec.description   = 'Finds you suitable appointments to register as Berlin citzen'
  spec.homepage      = 'https://github.com/dgmora/berlin_anmeldung_scrapper'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
