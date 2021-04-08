# frozen_string_literal: true

$VERBOSE = {'false' => false, 'true' => true}[ENV['VERBOSE']] if ENV['VERBOSE']

require 'bundler/setup'

require 'simplecov' if ENV['RUN_SIMPLECOV'] == 'true'

if ENV['RUN_CODECOV'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
elsif ENV['SILENT_SIMPLECOV'] == 'true'
  SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'mock_helpers/view'
require_relative 'mock_helpers/controller'
require 'minitest/autorun'
