require 'bundler/setup'

require 'single_cov'
SingleCov.setup :minitest

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'pagy'
require_relative 'array'
require "minitest/autorun"
