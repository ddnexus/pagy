# encoding: utf-8
# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

# The extras that override the built-in methods need to be tested in isolation in order
# to prevent them to change also the behavior and the result of the built-in tests.
# We exclude them from the :test_common task and create a new task for them, then added to the :default task

Rake::TestTask.new(:test_common) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList.new.include("test/**/*_test.rb").exclude('test/**/i18n_test.rb', 'test/**/items_test.rb', 'test/**/overflow_test.rb', 'test/**/trim_test.rb')
end

Rake::TestTask.new(:test_extra_i18n) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/i18n_test.rb']
end

Rake::TestTask.new(:test_extra_items) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/items_test.rb']
end

Rake::TestTask.new(:test_extra_overflow) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/overflow_test.rb']
end

Rake::TestTask.new(:test_extra_trim) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/trim_test.rb']
end

task :test => [:test_common, :test_extra_items, :test_extra_i18n, :test_extra_overflow, :test_extra_trim ]

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = `git ls-files -z`.split("\x0")     # limit rubocop to the files in the repo
end

task :default => [:test, :rubocop]
