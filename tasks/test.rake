# frozen_string_literal: true

require 'rake/testtask'

desc 'Run all tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test' # Ease the require
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
end
