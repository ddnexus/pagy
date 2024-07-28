# frozen_string_literal: true

require_relative '../test_helper'

describe 'Version match' do
  it 'has version' do
    _(Pagy::VERSION).wont_be_nil
  end
  it 'defines the same version in retype.yml' do
    _(File.read('./retype.yml')).must_match "label: #{Pagy::VERSION}"
  end
  it 'defines the same version in .github/ISSUE_TEMPLATE/Code.yml' do
    _(File.read('./.github/ISSUE_TEMPLATE/Code.yml')).must_match "I upgraded to pagy version #{Pagy::VERSION}"
  end
  it 'defines the same version in config/pagy.rb' do
    _(Pagy.root.join('config', 'pagy.rb').read).must_match "# Pagy initializer file (#{Pagy::VERSION})"
  end
  it 'defines the same version in bin/pagy' do
    _(Pagy.root.join('bin', 'pagy').read).must_match "VERSION = '#{Pagy::VERSION}'"
  end
  it 'defines the same version in apps/*.ru' do
    %w[calendar demo rails repro].each do |app|
      _(Pagy.root.join('apps', "#{app}.ru").read).must_match "VERSION = '#{Pagy::VERSION}'"
    end
  end
  it 'defines the same version in javascripts/pagy.min.js' do
    _(Pagy.root.join('javascripts', 'pagy.min.js').read).must_match "version:\"#{Pagy::VERSION}\","
  end
  it 'defines the same version in src/pagy.min.js.map' do
    _(Pagy.root.join('javascripts', 'pagy.min.js.map').read).must_match "version: \\\"#{Pagy::VERSION}\\\","
  end
  it 'defines the same version in src/pagy.mjs' do
    _(Pagy.root.join('javascripts', 'pagy.mjs').read).must_match "version: \"#{Pagy::VERSION}\","
  end
  it 'defines the same version in CHANGELOG.md' do
    _(Pagy.root.parent.join('CHANGELOG.md').read).must_match "## Version #{Pagy::VERSION}"
  end
  it 'defines the same minor version in ./quick-start.md' do
    _(File.read('./quick-start.md')).must_match "gem 'pagy', '~> #{Pagy::VERSION.sub(/\.\d+$/, '')}"
  end
end
