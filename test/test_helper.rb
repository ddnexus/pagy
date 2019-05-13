# encoding: utf-8
# frozen_string_literal: true

require 'bundler/setup'

require 'simplecov' if ENV['RUN_SIMPLECOV']

if ENV['RUN_CODECOV']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'mock_helpers/view'
require_relative 'mock_helpers/controller'
require "minitest/autorun"
