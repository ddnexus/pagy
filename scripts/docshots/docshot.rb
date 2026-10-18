#!/usr/bin/env ruby
# frozen_string_literal: true

# Capture the docs screenshots from the docshots.ru app
#   bundle exec ruby scripts/docshots/docshot.rb [OUTPUT_DIR]   # default: assets/images

require 'bundler/setup'
require 'ferrum'
require 'net/http'
require_relative '../../gem/lib/pagy'

port    = 8088
app_url = "http://localhost:#{port}"
app     = Pagy::ROOT.join('../scripts/docshots/docshots.ru')
outdir  = Pathname(ARGV[0] || Pagy::ROOT.join('../assets/images'))
outdir.mkpath

# Run the app in a sub process
pid = spawn("#{Pagy::ROOT}/bin/pagy #{app} -p #{port}")
puts "Waiting for server at #{app_url}..."
10.times do
  Net::HTTP.get(URI(app_url))
  break
rescue Errno::ECONNREFUSED
  sleep 1
end

begin
  browser = Ferrum::Browser.new(base_url: app_url, timeout: 30, browser_options: { 'no-sandbox' => nil })
  page    = browser.create_page
  page.set_viewport(width: 1280, height: 800, scale_factor: 2)
  # Wait for the network and the web fonts on every page: an in-flight font download
  # cancelled by the next navigation leaves the font stuck as "loading" in the following pages
  visit = lambda do |path|
    page.go_to(path)
    page.network.wait_for_idle
    page.evaluate_async('document.fonts.ready.then(() => arguments[0](true))', 10)
  end
  visit.call('/')
  hrefs = page.css('#links a').map { |a| a.attribute('href') }
  hrefs.each do |href|
    visit.call(href)
    filename = page.at_css('#target .filename').text.strip
    path     = outdir.join(filename)
    page.screenshot(path:, selector: '#target .backdrop', background_color: Ferrum::RGBA.new(0, 0, 0, 0.0))
    puts "Captured #{path}"
  end
ensure
  browser&.quit
  Process.kill('INT', pid)
  Process.wait(pid)
end
