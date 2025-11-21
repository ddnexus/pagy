# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'pagy'
  s.version     = '43.1.1'
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'Pagy 🐸 The Leaping Gem!'
  s.description = 'Agnostic pagination in plain ruby.'
  s.homepage    = 'https://github.com/ddnexus/pagy'
  s.license     = 'MIT'
  s.files       = `git ls-files -z`.split("\0")  # rubocop:disable Packaging/GemspecGit
                                   .reject { |f| f.end_with?('.md', '.gemspec') } \
                                   << 'LICENSE.txt'  # LICENSE.txt is copied and deleted around build
  s.metadata    = { 'rubygems_mfa_required' => 'true',
                    'homepage_uri'          => 'https://github.com/ddnexus/pagy',
                    'documentation_uri'     => 'https://ddnexus.github.io/pagy',
                    'bug_tracker_uri'       => 'https://github.com/ddnexus/pagy/issues',
                    'changelog_uri'         => 'https://ddnexus.github.io/pagy/changelog/',
                    'support'               => 'https://github.com/ddnexus/pagy/discussions/categories/q-a' }
  s.executables << 'pagy'
  s.add_dependency 'json'
  s.add_dependency 'yaml'
  s.required_ruby_version = '>= 3.2'
end
