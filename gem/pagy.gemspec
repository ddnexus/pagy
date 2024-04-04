# frozen_string_literal: true

require_relative 'lib/pagy'

Gem::Specification.new do |s|
  s.name        = 'pagy'
  s.version     = Pagy::VERSION
  s.authors     = ['Domizio Demichelis']
  s.email       = ['dd.nexus@gmail.com']
  s.summary     = 'The best pagination ruby gem'
  s.description = 'Agnostic pagination in plain ruby. It does it all. Better.'
  s.homepage    = 'https://github.com/ddnexus/pagy'
  s.license     = 'MIT'
  s.files       = Dir.glob('**/*')
                     .reject { |f| f.end_with?('.md', '.gemspec') }
                     .select { |f| File.file?(f) } + ['LICENSE.txt'] # LICENSE.txt is copied and deleted around build
  s.metadata    = { 'rubygems_mfa_required' => 'true',
                    'homepage_uri'          => 'https://github.com/ddnexus/pagy',
                    'documentation_uri'     => 'https://ddnexus.github.io/pagy',
                    'bug_tracker_uri'       => 'https://github.com/ddnexus/pagy/issues',
                    'changelog_uri'         => 'https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md',
                    'support'               => 'https://github.com/ddnexus/pagy/discussions/categories/q-a' }
  s.executables << 'pagy'
  s.post_install_message = <<~PIM
    *********************** PAGY WARNING! ***********************
               We may drop pagy's less used CSS extras.

          If you wish to keep them alive, please, vote here:

    https://github.com/ddnexus/pagy/discussions/categories/survey
    *************************************************************
  PIM
  s.required_ruby_version = '>= 3.1'
end
