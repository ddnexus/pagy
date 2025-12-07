# frozen_string_literal: true

SimpleCov.start do
  track_files 'gem/lib/**/*.rb'
  add_filter %w[test gem/lib/optimist.rb gem/lib/pagy/console.rb]
  enable_coverage :branch
end
