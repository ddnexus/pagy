# frozen_string_literal: true

# Gem release cycle
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks(dir: 'gem', name: 'pagy')

module Bundler # :nodoc: all
  class GemHelper
    def version_tag
      "#{@tag_prefix}#{version}"   # remove that stupid 'v' prepended to the version number
    end
  end
end

desc 'Checks-build-release-tag-cleanup cycle'
task :rubygem_release do
  output = `git status --porcelain`
  abort 'Working tree dirty!' unless output.empty?

  branch = `git rev-parse --abbrev-ref HEAD`
  abort 'Wrong branch to release!' unless /^master/.match?(branch)

  FileUtils.cp('LICENSE.txt', 'gem/LICENSE.txt')
  Rake::Task['build'].invoke
  FileUtils.rm_f('gem/LICENSE.txt')

  Rake::Task['release'].invoke
  FileUtils.rm_rf('gem/pkg', secure: true)
end
