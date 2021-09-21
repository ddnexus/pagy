# frozen_string_literal: true

$VERBOSE = { 'false' => false, 'true' => true }[ENV['VERBOSE']] if ENV['VERBOSE']

if ENV['CODECOV']
  require 'codecov' # require also simplecov
  # if you want the formatter to upload the results use SimpleCov::Formatter::Codecov instead
  SimpleCov.formatter = Codecov::SimpleCov::Formatter # upload with step in github actions
elsif !ENV['CI']
  require 'simplecov'
end

# we cannot use gemspec in the gemfile which would load pagy before simplecov so missing files from coverage
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagy'
require 'pagy/countless'
require 'rack'
require 'minitest/autorun'
# only direct terminal (RubyMine safe)
unless ENV['RM_INFO']
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end
