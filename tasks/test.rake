# frozen_string_literal: true

require 'rake/testtask'

# Separate tasks for each test that must run a process
# in isolation in order to avoid affecting also other tests.
test_tasks = {}

%w[ elasticsearch_rails
    headers
    i18n
    items
    items_trim
    overflow
    searchkick
    shared_json
    shared_oj
    standalone
    console
    support
    trim
    deprecation
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

# get the full list of of all the test tasks (and test files that each task run) with:
# rake -D test_*
