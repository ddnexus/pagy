# encoding: utf-8
# frozen_string_literal: true

require 'bundler/setup'

unless ENV['SKIP_SINGLECOV']
  require 'single_cov'
  SingleCov.setup(:minitest, branches: false)
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'test_helper/array'
require_relative 'test_helper/frontend'
require_relative 'test_helper/backend'
require "minitest/autorun"
