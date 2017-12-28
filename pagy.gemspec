
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

  s.summary       = %q{Because pagination should not suck!}
  s.description   = %q{Dead simple pagination in pure ruby. Easy, fast and very light. No restrictions imposed: use it with any MVC framework, any ORM, any DB type, any templating system or none at all. Use the built-in templates or create yours the way you want.}
  s.homepage      = 'https://github.com/ddnexus/pagy'
  s.license       = 'MIT'
  s.require_paths = ['lib']

  s.files         = `git ls-files -z`.split("\x0")
                                     .reject{|f| f.start_with? '.', 'test', 'Gemfile', 'Rakefile' }

  s.add_development_dependency 'bundler',  '~> 1.16'
  s.add_development_dependency 'rake',     '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'slim'
  s.add_development_dependency 'haml'
  s.add_development_dependency 'benchmark-ips'
  s.add_development_dependency 'kalibera'
  s.add_development_dependency 'memory_profiler'

end
