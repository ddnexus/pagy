# frozen_string_literal: true

source 'https://rubygems.org'

# gemspec

gem 'i18n'
gem 'oj', require: false     # false is for testing with or without it
gem 'rack'
gem 'rake'

gem 'puma'

group :test do
  gem 'codecov', require:  false
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rubocop', '~> 1.11', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'simplecov', require: false
  end

group :apps do
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

group :ide_development do
  gem 'debase'
  gem 'ruby-debug-ide'
end
