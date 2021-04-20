# encoding: utf-8
# frozen_string_literal: true

require 'json'

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
