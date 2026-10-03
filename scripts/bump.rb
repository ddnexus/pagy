#!/usr/bin/env ruby
# frozen_string_literal: true

# Update the files related to version changes
# Usage: scripts/bump.rb [patch|minor|major|X.Y.Z]

require 'tempfile'
require_relative 'scripty'
require_relative '../gem/apps/index'
include Scripty # rubocop:disable Style/MixinUsage

# Abort if the working tree is dirty
abort('Working tree dirty!') unless `git status --porcelain`.empty?

##### VERSION INPUT
# The old version is the latest release tag, which must match the Pagy::VERSION
require_relative '../gem/lib/pagy'
system('git fetch --tags --quiet origin')
old_version = Gem::Version.new(`git describe --tags --abbrev=0 origin/master`.chomp)
abort("Pagy::VERSION #{Pagy::VERSION} does not match the latest tag #{old_version}!") \
  unless Gem::Version.new(Pagy::VERSION) == old_version

major, minor, patch = old_version.segments
candidates = { 'patch' => "#{major}.#{minor}.#{patch + 1}",
               'minor' => "#{major}.#{minor + 1}.0",
               'major' => "#{major + 1}.0.0" }

input = ARGV.shift # empty ARGV, or Kernel#gets would read it as files
unless input
  puts "Latest release: #{old_version}"
  candidates.each_with_index { |(type, version), i| puts "  #{i + 1}) #{type.ljust(5)} #{version}" }
  print 'Choose 1-3, a type, or enter the version: '
  input = gets.chomp
  input = candidates.keys[input.to_i - 1] if input.match?(/\A[1-3]\z/)
end
input = candidates[input] || input

abort("Invalid version: #{input.inspect}") unless Gem::Version.correct?(input) && input.match?(/\A\d+\.\d+\.\d+\z/)
new_version = Gem::Version.new(input)
abort("Version #{new_version} must be greater than #{old_version}!") unless new_version > old_version
puts "Bumping #{old_version} -> #{new_version}"

##### GITLOG CREATION
# Create a tempfile with the formatted changes from the gem-filtered gitlog
gitlog = Scripty.generate_gem_log(old_version)

# Abort if there is no gem change
if gitlog.size.zero? # rubocop:disable Style/ZeroLengthPredicate -- (bug)
  system('git reset --hard')
  abort("No gem changes since version #{old_version}!")
end

# Edit the gitlog?
edit_file?(gitlog.path, 'Gitlog')

##### VERSION UPDATES
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

# Update the Gefile.lock
system('bundle lock --update pagy')

# Base version changes (x.y)
old_major, old_minor, = old_version.to_s.split('.')
new_major, new_minor, = new_version.to_s.split('.')
old_base_version      = "#{old_major}.#{old_minor}"
new_base_version      = "#{new_major}.#{new_minor}"

replace_string_in_file('docs/guides/quick-start.md', old_base_version, new_base_version)

next_path = 'docs/guides/pagy-next.md'
replace_string_in_file(next_path, old_version.to_s, new_version.to_s, all: true)
replace_string_in_file(next_path, old_base_version, new_base_version, all: true)

##### BUILD JAVASCRIPT (with the new versions)
# Build JavaScript files (to update the version)
system(Scripty::ROOT.join('src/build').to_s)

##### RELEASE BODY
# Prepare the .github/latest_release_body.md file.
# Used by .github/workflows/release.yml to create the GitHub release.
release_body_path = '.github/latest_release_body.md'

# Copy the whats_new from the README to the latest_release_body file
whats_new_content = extract_section_from_file('README.md', 'whats_new')
replace_section_in_file(release_body_path, 'whats_new', whats_new_content)

# Insert the changes into the latest_release_body file
changes = File.read(gitlog.path)
replace_string_in_file(release_body_path, "### Changes in #{old_version}", "### Changes in #{new_version}")
replace_section_in_file(release_body_path, 'changes', changes)

# Edit the Release Body?
edit_file?(release_body_path, 'Release Body')

##### CHANGELOG
# Add the changes to the CHANGELOG
replace_string_in_file('docs/CHANGELOG.md', /<hr>\n/, "<hr>\n\n#### Version #{new_version}\n\n#{changes}")
replace_string_in_file('docs/CHANGELOG.md', "(e.g. `#{old_version}`)", "(e.g. `#{new_version}`)")

# Run the test to check the consistency of versioning across files
unless system(%(ruby #{Pagy::ROOT.parent.join('test/unit/pagy/version_test.rb')}))
  system('git reset --hard')
  abort('Abort! Version inconsistencies!')
end

# Insert the latest ai-widget in the retype head
require_relative 'update_retype_head'

# Optional update of top 100
confirm_to('update the "Top 100 contributors"') do
  require_relative 'update_top100'
end

# Optional commit
confirm_to('commit the changes') do
  system('git add -A')
  system("git commit -m 'Version #{new_version}'")

  # Optional push: when the CI passes, run the "Release" workflow
  confirm_to('push the dev branch') do
    system('git push origin dev') &&
      puts("\nWhen the CI passes, run: gh workflow run release.yml -f version=#{new_version}")
  end
end
