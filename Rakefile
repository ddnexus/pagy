# encoding: utf-8
# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

# The extras that override the built-in methods need to be tested in isolation in order
# to prevent them to change also the behavior and the result of the built-in tests.
# We exclude them from the :test_main task and create a new task for them, then added to the :default task

Rake::TestTask.new(:test_main) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList.new.include("test/**/*_test.rb").exclude('test/**/i18n_test.rb', 'test/**/items_test.rb', 'test/**/overflow_test.rb', 'test/**/trim_test.rb', 'test/**/elasticsearch_rails_test.rb', 'test/**/searchkick_test.rb', 'test/**/support_test.rb', 'test/**/shared_test.rb')
end

Rake::TestTask.new(:test_extra_i18n) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList['test/**/i18n_test.rb']
end

Rake::TestTask.new(:test_extra_items) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList['test/**/items_test.rb']
end

Rake::TestTask.new(:test_extra_overflow) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList['test/**/overflow_test.rb']
end

Rake::TestTask.new(:test_extra_trim) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList['test/**/trim_test.rb']
end

Rake::TestTask.new(:test_extra_elasticsearch) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList['test/**/elasticsearch_rails_test.rb', 'test/**/searchkick_test.rb']
end

Rake::TestTask.new(:test_support) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList['test/**/support_test.rb']
end

Rake::TestTask.new(:test_shared) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList['test/**/shared_test.rb']
end

task :test => [:test_main, :test_extra_items, :test_extra_i18n, :test_extra_overflow, :test_extra_trim, :test_extra_elasticsearch, :test_support, :test_shared ]

if ENV['RUN_RUBOCOP']
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = `git ls-files -z`.split("\x0")     # limit rubocop to the files in the repo
    t.requires << 'rubocop-performance'
  end
  task :default => [:test, :rubocop]
else
  task :default => [:test]
end
