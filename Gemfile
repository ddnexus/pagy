# encoding: utf-8
# frozen_string_literal: true

source 'https://rubygems.org'

# gemspec

gem 'rake'
gem 'rack'
gem 'i18n'

gem 'oj', require: false     # false is for testing with or without it

group :test do
  gem 'codecov', require:  false
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'simplecov', require: false
end

group :apps do
  gem 'sinatra'
  gem 'sinatra-contrib'
  # gem 'slim'
  # gem 'haml'
end

# group :performance do
  # benchmark/profiling
  # gem 'benchmark-ips'
  # gem 'kalibera'
  # gem 'memory_profiler'
# end
