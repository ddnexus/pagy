#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../gem/lib/pagy/cli'
require 'net/http'

port     = 8088
app_url  = "http://localhost:#{port}"
app_path = "#{Pagy::ROOT}/../scripts/docshots/docshots.ru"

# Run the app in a sub process
pid = spawn("#{Pagy::ROOT}/bin/pagy #{app_path} -p #{port}")

# Wait for the server to be ready
puts "Waiting for server at #{app_url}..."
10.times do
  Net::HTTP.get(URI(app_url))
  break
rescue Errno::ECONNREFUSED
  sleep 1
end

# We run the capture.js
outdir  = Pagy::ROOT.join('../assets/images')
capture = Pagy::ROOT.join('../scripts/docshots/capture.js')
system("bun run #{capture} #{app_url} #{outdir}")

# Terminate the sub process
Process.kill('INT', pid)
Process.wait(pid)
