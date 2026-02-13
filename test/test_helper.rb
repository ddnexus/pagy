# frozen_string_literal: true

require 'simplecov' if ENV['COVERAGE']

$LOAD_PATH.unshift __dir__
$LOAD_PATH.unshift File.expand_path('../gem/lib', __dir__)

require 'pagy'

require 'minitest'
require 'minitest/spec'
Minitest.load :holdify
require 'minitest/autorun'
require 'minitest/mock'

require_relative 'helpers/minitest_backtraces'
