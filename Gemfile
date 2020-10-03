source "https://rubygems.org"

gem 'rake'
gem 'rack'
gem 'i18n'

gem 'oj', require: false     # false is for testing with or without it

gem 'puma'

group :test do
  gem 'rubocop', '~> 0.82.0'
  gem 'rubocop-performance', '~> 1.5.0'
  gem 'simplecov', require: false
  gem 'codecov', require:  false
  gem 'minitest'
  gem 'minitest-reporters'
end

# docs server
gem "github-pages", '208', group: :jekyll_plugins

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
