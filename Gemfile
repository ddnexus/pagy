source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# test
gem 'rake'
gem 'minitest'
gem 'rack'
gem 'i18n'
gem 'single_cov', '~> 1.3' unless ENV['SKIP_SINGLECOV']
# include minor since it constantly adds new cops
gem 'rubocop', '~> 0.63.1' unless ENV['SKIP_RUBOCOP']

# development
# gem 'slim'
# gem 'haml'

# benchmark/profiling
# gem 'benchmark-ips'
# gem 'kalibera'
# gem 'memory_profiler'

# docs server
#gem "github-pages", '193', group: :jekyll_plugins
