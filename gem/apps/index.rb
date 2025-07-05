# frozen_string_literal: true

# PagyApp module
module PagyApps
  # Return the hash of app name/path
  INDEX = Dir[File.expand_path('./*.ru', __dir__)].to_h { |f| [File.basename(f, '.ru'), f] }.freeze
end
