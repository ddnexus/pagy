# frozen_string_literal: true

# Add the 'test' directory (the directory containing this file) to the load path
$LOAD_PATH.unshift __dir__

# Add 'gem/lib' folder to load path (so you can require your actual code)
$LOAD_PATH.unshift File.expand_path('../gem/lib', __dir__)

# Coverage and Environment
require 'simplecov' unless ENV['SKIP_COVERAGE']

# Load the Gem
require 'pagy'

# Minitest Setup
require 'minitest'
require 'minitest/spec'
Minitest.load :rematch
require 'minitest/autorun'
require 'minitest/mock'

# Load Helpers (Order matters: Load lib patches before tests run)
require 'helpers/minitest_backtraces'
require 'helpers/url_assertions'
require 'helpers/models'
require 'helpers/test_case'
