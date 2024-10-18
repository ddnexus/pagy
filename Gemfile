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
  gem 'mutex_m'
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
  gem 'groupdate'
  gem 'puma'
  gem 'rackup'
  gem 'rails'
  gem 'rerun'
  gem 'rouge'
  gem 'sequel'
  gem 'sinatra'
  gem 'sinatra-contrib'
  # activerecord/sqlite3_adapter.rb probably useless) constraint !!!
  # https://github.com/rails/rails/blame/v7.1.3.4/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L14
  gem 'sqlite3', '~> 1.4.0'
  # Required because 2.7 requires ruby 3.2 and we are still testing 3.1
  gem 'zeitwerk', '< 2.7'
end

# group :performance do
#   gem 'benchmark-ips'
#   gem 'kalibera'
#   gem 'memory_profiler'
# end
