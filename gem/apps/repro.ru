# frozen_string_literal: true

# DESCRIPTION
#    Reproduce generic/simple issues
#
# DOC
#    https://ddnexus.github.io/pagy/playground/#1-repro-app
#
# BIN HELP
#    bundle exec pagy -h
#
# DEV USAGE
#    bundle exec pagy clone repro
#    bundle exec pagy ./repro.ru
#
# URL
#    http://0.0.0.0:8000

VERSION = '10.0.0'

if VERSION != Pagy::VERSION
  Warning.warn("\n>>> WARNING! '#{File.basename(__FILE__)}-#{VERSION}' running with 'pagy-#{Pagy::VERSION}'! <<< \n\n")
end
run_from_repo = Pagy::ROOT.join('pagy.gemspec').exist?

# Bundle
require 'bundler/inline'
gemfile(!run_from_repo) do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'puma'
  gem 'sinatra'
end

# Edit this section adding the legacy as needed
# Pagy initializer
Pagy.options[:client_max_limit] = 100

# Sinatra setup
require 'sinatra/base'
# Sinatra application
class PagyRepro < Sinatra::Base
  include Pagy::Method

  get('/javascript/:file') do
    format = params[:file].split('.').last
    if format == 'js'
      content_type 'application/javascript'
    elsif format == 'map'
      content_type 'application/json'
    end
    send_file Pagy::ROOT.join('javascript', params[:file])
  end

  # Edit this action as needed
  get '/' do
    collection = MockCollection.new
    @pagy, @records = pagy(collection)
    # @pagy, @records = pagy(:offset, collection, limit: 7, client_max_limit: 30)
    # @pagy, @records = pagy(:countless, collection)
    # @pagy, @records = pagy(Array(1..1000))
    # response.headers.merge!(@pagy.headers_hash)
    erb :main
  end

  # Views
  template :layout do
    <<~ERB
      <!DOCTYPE html>
      <html lang="en">
      <html>
      <head>
         <title>Pagy Repro App</title>
        <script src="javascript/pagy.js"></script>
        <script>
          window.addEventListener("load", Pagy.init);
        </script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style type="text/css">
          @media screen { html, body {
            font-size: 1rem;
            line-height: 1.2s;
            padding: 0;
            margin: 0;
          } }
          body {
            background: white !important;
            margin: 0 !important;
            font-family: sans-serif !important;
          }
          .content {
            padding: 1rem 1.5rem 2rem !important;
          }

          /* Quick demo for overriding the element style attribute of certain pagy helpers
          .pagy input[style] {
            width: 5rem !important;
          }
          */

          /*
            If you want to customize the style,
            please replace the line below with the actual file content
          */
          <%= Pagy::ROOT.join('stylesheet/pagy.css').read %>
        </style>
      </head>
      <body>
        <%= yield %>
      </body>
      </html>
    ERB
  end

  template :main do
    <<~ERB
      <div class="content">
        <h1>Pagy Repro App</h1>
        <p> Self-contained, standalone app usable to easily reproduce any pagy issue.</p>
        <p>Please, report the following versions in any new issue.</p>
        <h2>Versions</h4>
        <ul>
          <li>Ruby:    <%= RUBY_VERSION %></li>
          <li>Rack:    <%= Rack::RELEASE %></li>
          <li>Sinatra: <%= Sinatra::VERSION %></li>
          <li>Pagy:    <%= Pagy::VERSION %></li>
        </ul>

        <h3>Collection</h3>
        <p id="records">@records: <%= @records.join(',') %></p>

        <hr>

        <h4>@pagy.series_nav</h4>
        <%= @pagy.series_nav(id: 'series-nav', aria_label: 'Pages nav') %>

        <h4>@pagy.series_nav_js</h4>
        <%= @pagy.series_nav_js(id: 'series-nav-js', aria_label: 'Pages nav_js') %>

        <h4>@pagy.series_nav_js</h4>
        <%= @pagy.series_nav_js(id: 'series-nav-js-responsive', aria_label: 'Pages nav_js_responsove',
           steps: { 0 => 5, 500 => 7, 750 => 9, 1000 => 11 }) %>

        <h4>@pagy.input_nav_js</h4>
        <%= @pagy.input_nav_js(id: 'input-nav-js', aria_label: 'Pages input_nav_js') %>

        <h4>@pagy.limit_tag_js</h4>
        <%= @pagy.limit_tag_js(id: 'limit-tag-js') %>

        <h4>@pagy.info_tag</h4>
        <%= @pagy.info_tag(id: 'pagy-info') %>
      </div>
    ERB
  end
end

# Simple array-based collection that acts as a standard DB collection.
# Use it as a simple way to get a collection that acts as a AR scope, but without any DB
# or create an ActiveRecord class or anything else that you need instead
class MockCollection < Array
  def initialize(arr = Array(1..1000))
    super
    @collection = clone
  end

  def offset(value)
    @collection = self[value..]
    self
  end

  def limit(value)
    @collection[0, value]
  end

  def count(*)
    size
  end
end

run PagyRepro
