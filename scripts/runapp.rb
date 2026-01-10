# frozen_string_literal: true

# Run a pagy app using the local bin/pagy and entr for auto-reloading
# Usage: ruby scripts/runapp.rb APP [options]

require 'shellwords'

abort 'Error: "entr" is not installed.' unless system('command -v entr > /dev/null')

# Ensure we run from the repo root
Dir.chdir(File.expand_path('..', __dir__))

exec "git ls-files gem | entr -n -r ruby -I gem/lib gem/bin/pagy #{ARGV.shelljoin}"
