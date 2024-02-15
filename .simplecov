# frozen_string_literal: true

SimpleCov.formatter = if ENV['COVERAGE_REPORT'] == 'true'
                        SimpleCov::Formatter::HTMLFormatter
                      else
                        SimpleCov::Formatter::SimpleFormatter
                      end

SimpleCov.start do
  command_name "Task##{$PROCESS_ID}"  # best way to get a different id for the specific task
  merge_timeout 60
  enable_coverage :branch

  add_group 'All Extras', %w[lib/pagy/extras]
  add_group 'Core',       %w[lib/pagy.rb
                             lib/pagy/backend.rb
                             lib/pagy/console.rb
                             lib/pagy/countless.rb
                             lib/pagy/exceptions.rb
                             lib/pagy/frontend.rb
                             lib/pagy/i18n.rb
                             lib/pagy/url_helpers.rb]
  add_group 'Countless',  %w[lib/pagy/countless.rb
                             lib/pagy/extras/countless.rb]
  add_group 'Calendar',   %w[lib/pagy/extras/calendar.rb
                             lib/pagy/calendar]
  # add_filter "/test/"
  add_group 'Tests',      %w[test]
end
