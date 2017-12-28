
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pagy/version'
require 'date'

Gem::Specification.new do |spec|
  spec.name          = 'pagy'
  spec.version       = Pagy::VERSION
  spec.authors       = ['Domizio Demichelis']
  spec.email         = ['dd.nexus@gmail.com']
  spec.date          = Date.today.to_s

  spec.summary       = %q{Because pagination should not suck!}
  spec.description   = %q{Dead simple pagination in pure ruby. Easy, fast and very light. No restrictions imposed: use it with any MVC framework, any ORM, any DB type, any templating system or none at all. Use the built-in templates or create yours the way you want.}
  spec.homepage      = 'https://github.com/ddnexus/pagy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
