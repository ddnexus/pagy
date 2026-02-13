# frozen_string_literal: true

# Run a pagy app using the local bin/pagy and watchexec for auto-reloading
# Usage: ruby scripts/runapp.rb APP [options]

require 'shellwords'

abort 'Error: "watchexec" is not installed.' unless system('command -v watchexec > /dev/null')

# Ensure we run from the repo root
root = File.expand_path('..', __dir__)

exec("watchexec -r -w gem -- ruby -I gem/lib gem/bin/pagy #{ARGV.shelljoin}", chdir: root)
