SimpleCov.start do
  if ENV['RUN_CODECOV'] == 'true'
    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
  elsif ENV['SILENT_SIMPLECOV'] == 'true'
    SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter
  end
  SimpleCov.command_name "Task##{$PROCESS_ID}"
  SimpleCov.merge_timeout 20
  add_group 'Core', %w[lib/pagy.rb lib/pagy/countless.rb lib/pagy/backend.rb lib/pagy/frontend.rb lib/pagy/exceptions.rb]
  add_group 'Extras', 'lib/pagy/extras'
  add_group 'Tests', 'test'
end
