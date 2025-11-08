#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the files related to version changes

require 'tempfile'
require_relative 'scripty'
require_relative '../gem/apps/index'
include Scripty  # rubocop:disable Style/MixinUsage

# Abort if the working tree is dirty
abort('Working tree dirty!') unless `git status --porcelain`.empty?

# Prompt for the new version
require_relative '../gem/lib/pagy'
old_version = Gem::Version.new(Pagy::VERSION)
puts "Current Pagy::VERSION: #{old_version}"
print 'Enter the new version: '
new_version = Gem::Version.new(gets.chomp)

abort('Invalid version!') unless new_version > old_version

# Bump the version in files
(%w[docs/retype.yml
    .github/ISSUE_TEMPLATE/Code.yml
    gem/bin/pagy
    gem/config/pagy.rb
    gem/lib/pagy.rb
    gem/pagy.gemspec
    src/pagy.ts] +
    PagyApps::INDEX.values).each do |path|
  replace_string_in_file(path, old_version.to_s, new_version.to_s)
end

# Base version changes
old_major, old_minor, = old_version.to_s.split('.')
new_major, new_minor, = new_version.to_s.split('.')
old_base_version      = "#{old_major}.#{old_minor}"
new_base_version      = "#{new_major}.#{new_minor}"
replace_string_in_file('docs/CHANGELOG.md', old_base_version, new_base_version)
replace_string_in_file('docs/guides/quick-start.md', old_base_version, new_base_version)

# Build JavaScript files (to update the version)
system(Scripty::ROOT.join('src/build').to_s)

# Run the test to check the consistency of versioning across files
system('bundle exec rake test_version')

# Optional commit
confirm_to('commit the changes') do
  system('git add -A')
  system("git commit -m 'Version #{new_version}'")
end

confirm_to('finalize the version') do
  exec("ruby ./finalize.rb '#{old_version}'")
end
