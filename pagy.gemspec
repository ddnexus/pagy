# encoding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pagy'

Gem::Specification.new do |s|
  s.name        = 'pagy'
  s.version     = Pagy::VERSION
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'The Ultimate Pagination Ruby Gem'
  s.description = 'Agnostic pagination in plain ruby: it works with any framework, ORM and DB type, with all kinds of collections, even pre-paginated, scopes, Arrays, JSON data... Easy, powerful, fast and light.'
  s.homepage    = 'https://github.com/ddnexus/pagy'
  s.license     = 'MIT'
  s.files       = File.read('pagy.manifest').split
  s.required_ruby_version = ['>= 1.9', '< 3.0']   # rubocop:disable Gemspec/RequiredRubyVersion
  s.post_install_message = %q{
IMPORTANT: Pagy 4.8+ has been backported and supports ruby 2.5+ now!

If you run on ruby 2.5+, upgrading requires no change in the code
unless you are using the searchkick or the elasticsearch_rails extras
(and in that case it requires just a single rename).

See https://github.com/ddnexus/pagy for details.

}
end
