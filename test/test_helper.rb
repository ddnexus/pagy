require 'bundler/setup'

require 'single_cov'
SingleCov.setup :minitest

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'pagy'
require 'pagy/countless'
require 'rack'
require_relative 'test_helper/array'
require_relative 'test_helper/frontend'
require_relative 'test_helper/backend'
require "minitest/autorun"
