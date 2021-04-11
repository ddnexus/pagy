# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'

# Separate tasks for each test that must run a process
# in isolation in order to avoid affecting also other tests.
test_tasks = {}

%w[ headers
    i18n
    overflow
    support
    oj_shared
    shared
    trim
    items_trim
    items_countless
    items_elasticsearch
    elasticsearch_rails
    searchkick
].each do |name|
  task_name = :"test_#{name}"
  file_path = "test/**/#{name}_test.rb"
  test_tasks[task_name] = file_path
  Rake::TestTask.new(task_name) do |t|
    test_files    = FileList.new file_path
    t.test_files  = test_files
    t.description = "Run tests in #{test_files.join(', ')}"
  end
end

# Collect the other tests
Rake::TestTask.new(:test_others) do |t|
  test_files    = FileList.new.include('test/**/*_test.rb').exclude(*test_tasks.values)
  t.test_files  = test_files
  t.description = "Run tests in #{test_files.join(', ')}"
end

desc "Run all the test tasks: #{test_tasks.keys.join(', ')}"
task test: [*test_tasks.keys, :test_others]

task default: ( if ENV['RUN_RUBOCOP'] == 'true'
                  require 'rubocop/rake_task'
                  RuboCop::RakeTask.new(:rubocop) do |t|
                    t.options = `git ls-files | grep -E '\\.rb$'`.split("\n") # limit rubocop to the files in the repo
                  end
                  %i[test rubocop]
                else
                  [:test]
                end )

# get the full list of of all the test tasks
# (and test files that each task run) with:
# rake -D test_*
