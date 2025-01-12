# frozen_string_literal: true

require 'simplecov'

unless ENV['RM_INFO']   # RubyMine safe
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end

# We cannot use gemspec in the gemfile which would load pagy before simplecov so missing the coverage
lib =  File.expand_path('../gem/lib/', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'pagy'
require 'minitest/autorun'

require_relative 'helpers/warning_filters'
