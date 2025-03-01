# frozen_string_literal: true

SimpleCov.formatter = if ENV['COVERAGE_REPORT'] == 'true'
                        SimpleCov::Formatter::HTMLFormatter
                      else
                        SimpleCov::Formatter::SimpleFormatter
                      end

SimpleCov.start do
  command_name "Task##{$PROCESS_ID}"  # best way to get a different id for the specific task
  merge_timeout 120
  enable_coverage :branch

  add_group 'Core',   %w[gem/lib/pagy.rb gem/lib/pagy]
  add_group 'Extras', 'gem/lib/pagy/extras'
  add_group 'Mixins', 'gem/lib/pagy/mixins'
  add_group 'Tests',  'test'
end
