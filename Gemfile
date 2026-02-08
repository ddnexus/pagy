# frozen_string_literal: true

source 'https://rubygems.org'

gemspec path: './gem'

gem 'rdoc', '7.0.3'  # temporarily use the ruby 4.0 old one (ruby image), to avoid warnings

group :development do
  gem 'debug'
  gem 'http'           # used by the scripts/contributor-list.rb
  gem 'irb'
  gem 'ruby-lsp', require: false
  gem 'sorbet', require: false
  gem 'tapioca', require: false
end

group :test do
  gem 'activesupport'
  gem 'i18n'
  gem 'minitest'
  gem 'minitest-holdify'
  gem 'minitest-mock'
  gem 'minitest-reporters'
  gem 'oj', require: false     # false is for testing with or without it
  gem 'rack'
  gem 'rails-i18n'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-packaging'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'rubocop-shopify'
  gem 'rubocop-thread_safety'
  gem 'simplecov', require: false
end

group :playground do
  gem 'groupdate'
  gem 'puma'
  gem 'rackup'
  gem 'rails', '~> 8.0'
  gem 'rouge'
  gem 'sequel'
  gem 'sinatra'
  gem 'sqlite3'
end

group :performance do
  # gem 'benchmark-ips'
  # gem 'kalibera'
  # gem 'memory_profiler'
end
