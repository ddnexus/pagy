# frozen_string_literal: true

# Gem release cycle

require 'bundler/gem_tasks'
require 'rake/manifest'

Rake::Manifest::Task.new do |t|
  t.patterns      = FileList.new.include('lib/**/*', 'LICENSE.txt').exclude('**/*.md')
  t.manifest_file = 'pagy.manifest'
end

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

  Rake::Task['manifest:check'].invoke
  Rake::Task['build'].invoke
  Rake::Task['release'].invoke
  FileUtils.rm_rf('pkg', secure: true)
end
