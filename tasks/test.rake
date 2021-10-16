# frozen_string_literal: true

require 'rake/testtask'

# Almost each test recreates a different environment,
# and must run in a separate process in order to avoid
# to override other tests so we create one task per test.
# That's a bit slow but consistent and easier when developing.

# Use the :test task to run them all

# Get the full list of of all the test tasks (and test files that each task run) with:
# rake -D test_*

names = []
FileList.new.include('test/**/*_test.rb').each do |path|
  name = "test_#{path[0..-9].split('/').last}".to_sym
  names << name
  Rake::TestTask.new(name) do |t|
    t.test_files  = [path]
    t.description = "Run tests in #{path}"
  end
end

desc "Run all the test tasks: #{names.join(', ')}"
task test: [*names]
