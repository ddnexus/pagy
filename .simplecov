# frozen_string_literal: true

SimpleCov.start do
  SimpleCov.formatter = SimpleCov::Formatter::SimpleFormatter unless ENV['CI'] || ENV['HTML_REPORTS'] == 'true'
  SimpleCov.command_name "Task##{$PROCESS_ID}"
  SimpleCov.merge_timeout 20
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
