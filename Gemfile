# frozen_string_literal: true

source 'https://rubygems.org'

# we cannot use gemspec here because it would load pagy before simplecov so missing files from coverage
# gemspec

gem 'i18n'
gem 'oj', require: false     # false is for testing with or without it
gem 'rack'
gem 'rake'
gem 'rake-manifest'
gem 'rerun'
gem 'solargraph'  # run bundle exec yard gems to index installed and cached gems

group :test do
  gem 'codecov', require:  false
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rematch'
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-packaging'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'simplecov', require: false
end

group :apps do
  gem 'puma'
  gem 'sinatra'
  gem 'sinatra-contrib'
  # gem 'slim'
  # gem 'haml'
end

group :performance do
  gem 'benchmark-ips'
  gem 'kalibera'
  gem 'memory_profiler'
end
