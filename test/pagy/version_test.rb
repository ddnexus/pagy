# frozen_string_literal: true

require_relative '../test_helper'

# Load PagyApps::INDEX
# Using Pagy::ROOT to locate the file robustly regardless of test file location
require Pagy::ROOT.join('apps/index').to_s

describe 'Version match' do
  let(:version)   { Pagy::VERSION }
  let(:major)     { version.split('.')[0] }
  let(:minor)     { version.split('.')[1] }

  # Pagy::ROOT is 'gem/'. We assume the repo root is one level up.
  let(:repo_root) { Pagy::ROOT.parent }

  it 'has version' do
    _(version).wont_be_nil
  end

  describe 'Documentation and Config' do
    it 'matches in retype.yml' do
      content = repo_root.join('docs/retype.yml').read
      _(content).must_match "label: #{version}"
    end

    it 'matches in .github/ISSUE_TEMPLATE/Code.yml' do
      content = repo_root.join('.github/ISSUE_TEMPLATE/Code.yml').read
      _(content).must_match "I upgraded to pagy version #{version}"
    end

    it 'matches in config/pagy.rb' do
      content = Pagy::ROOT.join('config/pagy.rb').read
      _(content).must_match "# Pagy initializer file (#{version})"
    end

    it 'matches in bin/pagy' do
      content = Pagy::ROOT.join('bin/pagy').read
      _(content).must_match "VERSION = '#{version}'"
    end

    it 'matches in quick-start.md (minor version)' do
      content = repo_root.join('docs/guides/quick-start.md').read
      _(content).must_match "gem 'pagy', '~> #{major}.#{minor}"
    end

    it 'has a section in CHANGELOG.md' do
      content = repo_root.join('docs/CHANGELOG.md').read
      _(content).must_match "## Version #{version}"
    end
  end

  describe 'App Racks' do
    it 'matches in apps/*.ru' do
      PagyApps::INDEX.each_value do |path|
        content = File.read(path)
        _(content).must_match "VERSION = '#{version}'"
      end
    end
  end

  describe 'Javascript Assets' do
    let(:js_path) { Pagy::ROOT.join('javascripts') }

    it 'matches in pagy.min.js' do
      _(js_path.join('pagy.min.js').read).must_match "version:\"#{version}\","
    end

    it 'matches in pagy.js' do
      _(js_path.join('pagy.js').read).must_match "version: \"#{version}\","
    end

    it 'matches in pagy.js.map' do
      _(js_path.join('pagy.js.map').read).must_match "version: \\\"#{version}\\\","
    end

    it 'matches in pagy.mjs' do
      _(js_path.join('pagy.mjs').read).must_match "version: \"#{version}\","
    end
  end
end
