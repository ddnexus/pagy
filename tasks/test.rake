# frozen_string_literal: true

require 'rake/testtask'
require_relative '../test/e2e/helpers/pagy_app'

# Helper to define tasks
def define_test_task(name, pattern)
  Rake::TestTask.new(name) do |t|
    t.libs    = %w[gem/lib test]
    t.pattern = pattern
    t.warning = true
  end
end

# Task for all tests
define_test_task(:test, 'test/**/*_test.rb')

namespace :test do
  # Task for Unit tests only
  define_test_task(:unit, 'test/unit/**/*_test.rb')

  # Task for E2E tests only
  define_test_task(:e2e, 'test/e2e/**/*_test.rb')

  namespace :e2e do
    E2eApp::APPS.each_key do |app|
      define_test_task(app, "test/e2e/#{app}_test.rb")
    end
  end
end
