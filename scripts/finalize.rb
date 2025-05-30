#!/usr/bin/env ruby
# frozen_string_literal: true

# Do not use with major versions with custom description format
# Finalize the files related to the publication of the version

require 'tempfile'
require_relative 'scripty'
include Scripty  # rubocop:disable Style/MixinUsage
require 'sem_version'

# Abort if the working tree is dirty
abort('Working tree dirty!') unless `git status --porcelain`.empty?

# Prompt for the old version tag
require_relative '../gem/lib/pagy'
new_version = SemVersion.new(Pagy::VERSION)
puts "Current Pagy::VERSION: #{new_version}"
print 'Enter the old version tag: '
old_version = SemVersion.new(gets.chomp)

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
# Insert the changes into the latest_release_body file
changes = File.read(gitlog.path)
replace_section_in_file(release_body_path, 'changes', changes)

# Edit the Release Body?
edit_file?(release_body_path, 'Release Body')

# Add the changes to the CHANGELOG
replace_string_in_file('docs/CHANGELOG.md', /<hr>\n/, "<hr>\n\n## Version #{new_version}\n\n#{changes}")

# Insert the latest ai-widget in the retype head
require_relative 'update_retype_head'

# Optional update of top 100
confirm_to('update the "Top 100 contributors"') do
  require_relative 'update_top100'
end

# Optional commit
confirm_to('commit the changes') do
  system('git add -A')
  system("git commit -m 'Finalize changes'")
end
