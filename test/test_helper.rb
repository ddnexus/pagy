# frozen_string_literal: true

# rubocop:disable Lint/RedundantCopDisableDirective, Style/FetchEnvVar
$VERBOSE = { 'false' => false, 'true' => true }[ENV['VERBOSE']] if ENV['VERBOSE']
# rubocop:enable Lint/RedundantCopDisableDirective, Style/FetchEnvVar

require_relative 'coverage_setup' unless ENV['RUBYMINE_SIMPLECOV_COVERAGE_PATH']  # skipped if RubyMine run with coverage

unless ENV['RM_INFO']   # RubyMine safe
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end

# we cannot use gemspec in the gemfile which would load pagy before simplecov so missing files from coverage
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagy'
require 'minitest/autorun'
