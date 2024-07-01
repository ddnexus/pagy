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

  add_group 'All Extras', %w[gem/lib/pagy/extras]
  add_group 'Core',       %w[gem/lib/pagy.rb
                             gem/lib/pagy/backend.rb
                             gem/lib/pagy/console.rb
                             gem/lib/pagy/countless.rb
                             gem/lib/pagy/exceptions.rb
                             gem/lib/pagy/frontend.rb
                             gem/lib/pagy/i18n.rb
                             gem/lib/pagy/url_helpers.rb]
  add_group 'Countless',  %w[gem/lib/pagy/countless.rb
                             gem/lib/pagy/extras/countless.rb]
  add_group 'Calendar',   %w[gem/lib/pagy/extras/calendar.rb
                             gem/lib/pagy/calendar]
  add_group 'Tests',      %w[test]
end
