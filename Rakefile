# frozen_string_literal: true

require 'bundler/setup'

Rake.add_rakelib 'tasks'

desc 'Run the unit test suite'
task :test do
  script = 'Dir.glob("test/unit/**/*_test.rb").sort.each { |f| require "./" + f }'
  sh Gem.ruby, '-Igem/lib:test', '-e', script
end

task default: :test
