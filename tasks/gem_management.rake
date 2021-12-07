# frozen_string_literal: true

# gGem build and release tasks, with added checks and patches
# Notice: this task is functional but the .github/workflows/release-gem.yml provides an easier way to do the same

require 'bundler/gem_tasks'
require 'rake/manifest'

Rake::Manifest::Task.new do |t|
  t.patterns      = FileList.new.include('lib/**/*', 'LICENSE.txt').exclude('**/*.md')
  t.manifest_file = 'pagy.manifest'
end

desc 'Build the gem, checking the manifest first'
task build: 'manifest:check'

module Bundler # :nodoc: all
  class GemHelper
    def version_tag
      "#{@tag_prefix}#{version}"   # remove that stupid 'v' prepended to the version number
    end
  end
end

desc 'Release the gem, checking the manifest first'
task release: 'manifest:check'
