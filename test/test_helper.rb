# encoding: utf-8
# frozen_string_literal: true

$VERBOSE = {'false' => false, 'true' => true}[ENV['VERBOSE']] if ENV['VERBOSE']

require 'bundler/setup'

require 'simplecov' if ENV['RUN_SIMPLECOV'] == 'true'

if ENV['RUN_CODECOV'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
else
  SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter if ENV['SILENT_SIMPLECOV'] == 'true'
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'mock_helpers/view'
require_relative 'mock_helpers/controller'
require "minitest/autorun"
