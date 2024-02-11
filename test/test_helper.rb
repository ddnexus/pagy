# frozen_string_literal: true

require 'simplecov' unless ENV['RUBYMINE_SIMPLECOV_COVERAGE_PATH']  # skipped if RubyMine run with coverage

unless ENV['RM_INFO']   # RubyMine safe
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end

# We cannot use gemspec in the gemfile which would load pagy before simplecov so missing the coverage
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagy'
require 'minitest/autorun'

require_relative 'helper/warning_filters'
require_relative 'helper/nav_tests'
