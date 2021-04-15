# encoding: utf-8
# frozen_string_literal: true

require 'bundler/setup'

if ENV['CODECOV']
  require 'codecov'
  SimpleCov.formatter = Codecov::SimpleCov::Formatter
elsif !ENV['CI']
  require 'simplecov'
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'mock_helpers/view'
require_relative 'mock_helpers/controller'
require "minitest/autorun"
