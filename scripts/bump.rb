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

# Create a tempfile with the formatted changes from the gem-filtered gitlog
gitlog  = Tempfile.new
commits = `git rev-list "#{old_version}"..HEAD`.split("\n")
commits.each do |commit|
  next if `git show --pretty="format:" --name-only --relative=gem #{commit}`.empty?

  subject = `git show --no-patch --format="- %s" #{commit}`.chomp
  next if subject.match?('\[skip-log\]')

  gitlog.puts subject
  body = `git show --no-patch --format="%b" #{commit}`.chomp
  next if body.empty?

  lines = body.split("\n")
  body  = lines.map { |line| "  #{line}" }.join("\n")
  gitlog.puts body
end
# Abort if there is no gem change
abort("No gem changes since version #{old_version}!") if gitlog.size.zero? # rubocop:disable Style/ZeroLengthPredicate -- (bug)

gitlog.close

# Edit the gitlog?
edit_file?(gitlog.path, 'Gitlog')

# Prepare the .github/latest_release_body.md file
# Used by .github/workflows/create_release.yml which is triggered by the :rubygem_release task (push tag)
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

# Add the changes to the CHANGELOG
replace_string_in_file('docs/CHANGELOG.md', /<hr>\n/, "<hr>\n\n## Version #{new_version}\n\n#{changes}")
replace_string_in_file('docs/CHANGELOG.md', "(e.g. `#{old_version}", "(e.g. `#{new_version}")

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
end
