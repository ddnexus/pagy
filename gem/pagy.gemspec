# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'pagy'
  s.version     = '9.1.0'
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'The best pagination ruby gem'
  s.description = 'Agnostic pagination in plain ruby. It does it all. Better.'
  s.homepage    = 'https://github.com/ddnexus/pagy'
  s.license     = 'MIT'
  s.files       = `git ls-files -z`.split("\0")  # rubocop:disable Packaging/GemspecGit
                                   .reject { |f| f.end_with?('.md', '.gemspec') } \
                                   << 'LICENSE.txt'  # LICENSE.txt is copied and deleted around build
  s.metadata    = { 'rubygems_mfa_required' => 'true',
                    'homepage_uri'          => 'https://github.com/ddnexus/pagy',
                    'documentation_uri'     => 'https://ddnexus.github.io/pagy',
                    'bug_tracker_uri'       => 'https://github.com/ddnexus/pagy/issues',
                    'changelog_uri'         => 'https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md',
                    'support'               => 'https://github.com/ddnexus/pagy/discussions/categories/q-a' }
  s.executables << 'pagy'
  s.required_ruby_version = '>= 3.1'
end
