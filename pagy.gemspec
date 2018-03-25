
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pagy'
require 'date'

Gem::Specification.new do |s|
  s.name          = 'pagy'
  s.version       = Pagy::VERSION
  s.authors       = ['Domizio Demichelis']
  s.email         = ['dd.nexus@gmail.com']
  s.date          = Date.today.to_s

  s.summary       = 'The Ultimate Pagination Ruby Gem'
  s.description   = 'Agnostic pagination in plain ruby: it works with any framework, ORM and DB type, with all kinds of collections, even pre-paginated, scopes, Arrays, JSON data... and just whatever you can count. Easy to use and customize, very fast and very light.'
  s.homepage      = 'https://github.com/ddnexus/pagy'
  s.license       = 'MIT'
  s.require_paths = ['lib']

  s.files         = `git ls-files -z`.split("\x0").select{|f| f.start_with?('lib', 'pagy.gemspec', 'LICENSE', 'README', 'images') }


  s.add_development_dependency 'bundler',  '~> 1.16'
  s.add_development_dependency 'rake',     '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'slim'
  s.add_development_dependency 'haml'
  s.add_development_dependency 'benchmark-ips'
  s.add_development_dependency 'kalibera'
  s.add_development_dependency 'memory_profiler'

end
