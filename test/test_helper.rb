# frozen_string_literal: true

$VERBOSE = {'false' => false, 'true' => true}[ENV['VERBOSE']] if ENV['VERBOSE']

if ENV['RUN_CODECOV']
  require 'codecov'   # requires also simplecov
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
else
  require 'simplecov'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'mock_helpers/view'
require_relative 'mock_helpers/controller'
require 'minitest/autorun'
