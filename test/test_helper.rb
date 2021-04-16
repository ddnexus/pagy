# frozen_string_literal: true

$VERBOSE = {'false' => false, 'true' => true}[ENV['VERBOSE']] if ENV['VERBOSE']

if ENV['CODECOV']
  require 'codecov'   # requires also simplecov
  # if you want the formatter to upload the results use SimpleCov::Formatter::Codecov instead
  SimpleCov.formatter = Codecov::SimpleCov::Formatter  # upload with step in github actions
elsif !ENV['CI']
  require 'simplecov'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'mock_helpers/view'
require_relative 'mock_helpers/controller'
require 'minitest/autorun'
