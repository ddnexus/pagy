# frozen_string_literal: true

require 'simplecov'

# Coverage by SimpleCov/CodeCov
if ENV['CODECOV']
  require 'codecov' # require also simplecov
  # if you want the formatter to upload the results use SimpleCov::Formatter::Codecov instead
  SimpleCov.formatter = Codecov::SimpleCov::Formatter # upload with step in github actions
elsif !ENV['CI']   # exclude in CI
  SimpleCov.configure do
    command_name "Task##{$PROCESS_ID}"
    merge_timeout 60
    enable_coverage :branch
    add_group 'All Extras', 'lib/pagy/extras'
    add_group 'Core', %w[ lib/pagy.rb
                          lib/pagy/backend.rb
                          lib/pagy/console.rb
                          lib/pagy/countless.rb
                          lib/pagy/exceptions.rb
                          lib/pagy/frontend.rb
                          lib/pagy/i18n.rb
                          lib/pagy/url_helpers.rb ]
    add_group 'Countless', %w[ lib/pagy/countless.rb
                               lib/pagy/extras/countless.rb ]
    add_group 'Calendar', %w[ lib/pagy/extras/calendar.rb
                              lib/pagy/calendar ]
    # add_filter "/test/"
    add_group 'Tests', 'test'
  end

  SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter unless ENV.fetch('HTML_REPORTS', nil) == 'true'
  SimpleCov.start
end
