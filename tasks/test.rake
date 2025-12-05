# frozen_string_literal: true

require 'rake/testtask'

desc 'Run all tests'
Rake::TestTask.new(:test) do |t|
  # Ease the require
  t.libs << 'lib' << 'test'

  # Glob pattern to find all test files
  t.pattern = 'test/**/*_test.rb'

  # Optional: Print the command being run
  t.verbose = true

  # Optional: Enable warnings (good for strict development)
  # t.warning = true
end
