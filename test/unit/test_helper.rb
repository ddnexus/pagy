# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter # create the HTML report
  SimpleCov.start do
    cover 'gem/lib/**/*.rb'
    name = ENV.fetch('COMMAND_NAME', '')
    coverage_dir("coverage/#{name}")
    command_name(name)
    enable_coverage :branch
  end
end

require_relative '../test_helper'

$LOAD_PATH.unshift __dir__

require_relative 'helpers/url_assertions'
require_relative 'helpers/models'
require_relative 'helpers/test_case'
