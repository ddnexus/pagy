# frozen_string_literal: true

SimpleCov.start do
  track_files 'gem/lib/**/*.rb'
  add_filter %w[test gem/lib/pagy/cli.rb gem/lib/pagy/console.rb]
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100
end
