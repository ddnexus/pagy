source "https://rubygems.org"

gemspec

gem 'rake'
gem 'rack'
gem 'i18n'

gem 'oj', require: false     # false is for testing with or without it

gem 'puma'

group :test do
  gem 'rubocop', '~> 1.11', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-minitest', require: false
  gem 'simplecov', require: false
  gem 'codecov', require:  false
  gem 'minitest'
  gem 'minitest-reporters'
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
