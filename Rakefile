# encoding: utf-8
# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'json'

if ENV['RUBOCOP'] || !ENV['CI']
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:rubocop)
end

# Separate tasks for each test that must run a process
# in isolation in order to avoid affecting also other tests.
test_tasks = {}

%w[ headers
    i18n
    i18n_old
    overflow
    support
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

desc 'Display SimpleCov coverage summary'
task :coverage_summary do
  last_run = JSON.parse(File.read('coverage/.last_run.json'))
  result   = last_run['result']['line']
  puts "\n>>> SimpleCov Coverage: #{result}% <<<"
  if result < 100.0
    Warning.warn "!!!!! Missing #{(100.0 - result).round(2)}% coverage !!!!!"
    puts "\n(run it again with COVERAGE_REPORT=true for a line-by-line HTML report @ coverage/index.html)" unless ENV['COVERAGE_REPORT']
  end
end

# get the full list of of all the test tasks (and test files that each task run) with:
# rake -D test_*
desc "Run all the test tasks: #{test_tasks.keys.join(', ')}"
task test: [*test_tasks.keys, :test_others]

task default: [:test, :rubocop, :coverage_summary]
