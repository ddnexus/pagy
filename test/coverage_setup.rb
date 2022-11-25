# frozen_string_literal: true

# Coverage by SimpleCov/CodeCov
if ENV['CODECOV']
  require 'codecov' # require also simplecov
  # if you want the formatter to upload the results use SimpleCov::Formatter::Codecov instead
  SimpleCov.formatter = Codecov::SimpleCov::Formatter # upload with step in github actions
elsif !ENV['CI']   # exclude in CI
  require 'simplecov'
  SimpleCov.configure do
    command_name "Task##{$PROCESS_ID}"
    merge_timeout 20
    enable_coverage :branch
    add_group 'Core', %w[ lib/pagy.rb
                          lib/pagy/backend.rb
                          lib/pagy/console.rb
                          lib/pagy/countless.rb
                          lib/pagy/exceptions.rb
                          lib/pagy/frontend.rb
                          lib/pagy/i18n.rb
                          lib/pagy/url_helpers.rb ]
    add_group 'Extras', 'lib/pagy/extras'
    add_group 'Tests', 'test'
  end

  SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter unless ENV.fetch('HTML_REPORTS', nil) == 'true'
  SimpleCov.start
end
