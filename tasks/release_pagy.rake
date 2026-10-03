# frozen_string_literal: true

# Gem release cycle
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks(dir: 'gem', name: 'pagy')

module VersionTagOverride
  def version_tag = "#{@tag_prefix}#{version}"
end
Bundler::GemHelper.prepend VersionTagOverride

# Manual fallback of the .github/workflows/release.yml (it does not create the GitHub release)
desc 'Checks-build-release-tag-cleanup cycle'
task :release_pagy do
  abort 'Working tree dirty!' unless `git status --porcelain`.empty?
  abort 'Wrong branch!' unless /^master/.match?(`git rev-parse --abbrev-ref HEAD`)

  cp('LICENSE.txt', 'gem/LICENSE.txt')
  Rake::Task['release'].invoke
ensure
  rm_f('gem/LICENSE.txt')
  rm_rf('gem/pkg', secure: true)
end
