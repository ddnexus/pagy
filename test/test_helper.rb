# frozen_string_literal: true

$VERBOSE = { 'false' => false, 'true' => true }[ENV.fetch('VERBOSE')] if ENV['VERBOSE']

require_relative 'coverage_setup' unless ENV['RUBYMINE_SIMPLECOV_COVERAGE_PATH']  # skipped if RubyMine run with coverage

unless ENV['RM_INFO']   # RubyMine safe
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end

# we cannot use gemspec in the gemfile which would load pagy before simplecov so missing files from coverage
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagy'
require 'minitest/autorun'
