# frozen_string_literal: true

require 'simplecov'

unless ENV['RM_INFO']   # RubyMine safe
  require "minitest/reporters"
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
end

require_relative '../gem/lib/pagy'
require 'minitest/autorun'

require_relative 'helpers/warning_filters'
