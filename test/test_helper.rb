# frozen_string_literal: true

$LOAD_PATH.unshift __dir__
$LOAD_PATH.unshift File.expand_path('../gem/lib', __dir__)

require 'simplecov' if ENV['CI'] || ENV['COVERAGE']

require 'pagy'

require 'minitest'
require 'minitest/spec'
Minitest.load :holdify
require 'minitest/autorun'
require 'minitest/mock'

require 'helpers/minitest_backtraces'
require 'helpers/url_assertions'
require 'helpers/models'
require 'helpers/test_case'
