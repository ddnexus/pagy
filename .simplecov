# frozen_string_literal: true

SimpleCov.formatter = if ENV['COVERAGE_REPORT'] == 'true'
                        SimpleCov::Formatter::HTMLFormatter
                      else
                        SimpleCov::Formatter::SimpleFormatter
                      end
SimpleCov.start do
  # track_files 'gem/lib/**/*.rb'
  add_filter %w[test gem/lib/optimist.rb]
  enable_coverage :branch
end
