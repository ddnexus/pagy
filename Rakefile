# encoding: utf-8
# frozen_string_literal: true

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'

# The extras that override the built-in methods need to be tested in isolation in order
# to prevent them to change also the behavior and the result of the built-in tests.
# We create a single task for each of them
@test_tasks = {}

def define_test_task(name, *files)
  @test_tasks[name] = files
  Rake::TestTask.new(name) do |t|
    t.libs += %w[test lib]
    t.test_files = FileList[*files]
  end
end

define_test_task :test_extra_items, 'test/**/items_test.rb'
define_test_task :test_extra_headers, 'test/**/headers_test.rb'
define_test_task :test_extra_i18n, 'test/**/i18n_test.rb'
define_test_task :test_extra_overflow, 'test/**/overflow_test.rb'
define_test_task :test_extra_trim, 'test/**/trim_test.rb'
define_test_task :test_extra_elasticsearch, 'test/**/elasticsearch_rails_test.rb', 'test/**/searchkick_test.rb'
define_test_task :test_support, 'test/**/support_test.rb'
define_test_task :test_shared,'test/**/shared_test.rb'
define_test_task :test_shared_combo, 'test/**/shared_combo_test.rb'

# We exclude the files of the other tasks from the :test_main task
Rake::TestTask.new(:test_main) do |t|
  t.libs += %w[test lib]
  t.test_files = FileList.new
                         .include('test/**/*_test.rb')
                         .exclude(*@test_tasks.values.flatten)
end

desc 'Run all the individual test tasks'
task :test => [:test_main, *@test_tasks.keys]

if ENV['RUN_RUBOCOP'] == 'true'
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:rubocop) do |t|
    t.options = `git ls-files -z`.split("\x0")     # limit rubocop to the files in the repo
    t.requires << 'rubocop-performance'
  end
  task :default => [:test, :rubocop]
else
  task :default => [:test]
end