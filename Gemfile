# frozen_string_literal: true

source 'https://rubygems.org'

gemspec path: './gem'

gem 'http'         # used by the scripts/contributor-list.rb
gem 'rake'

group :test do
  gem 'activesupport'
  gem 'i18n'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'oj', require: false     # false is for testing with or without it
  gem 'rack'
  gem 'rematch'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-packaging'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'simplecov', require: false
end

group :playground do
  gem 'puma'
  gem 'rackup'
  gem 'rerun'
  gem 'rouge'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# group :performance do
#   gem 'benchmark-ips'
#   gem 'kalibera'
#   gem 'memory_profiler'
# end
