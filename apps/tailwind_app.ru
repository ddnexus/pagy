# frozen_string_literal: true

# Self-contained, standalone Sinatra app usable to play with pagy with tailwind
# and/or easily reproduce any pagy issue.

# Copy this file in your own machine and
# ensure rack is installed (or `gem install rack`)
# or run it from the apps dir in the repo

# USAGE:
#    rackup -o 0.0.0.0 -p 8080 tailwind_app.ru

# ADVANCED USAGE (with automatic app reload if you edit it):
#    gem install rerun
#    rerun -- rackup -o 0.0.0.0 -p 8080 tailwind_app.ru

# Point your browser to http://0.0.0.0:8080

# Read the comments below to edit this app

require 'bundler/inline'

# Edit this gemfile declaration as you need
# and ensure to use gems updated to the latest versions
# NOTICE: if you get any installation error with the following setup
# temporarily remove the Gemfile and Gemfile.lock from the repo (they may interfere with the bundler/inline)

gemfile true do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'rack'
  gem 'rackup'
  # gem 'pagy'            # <--install from rubygems
  gem 'pagy', path: '../' # <-- use the local repo
  gem 'puma'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# Edit this section adding/removing the extras and Pagy::DEFAULT as needed
# pagy initializer
require 'pagy/extras/navs'
require 'pagy/extras/items'
# Pagy::DEFAULT[:items_extra] = false # opt-in
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:size]     = [1, 4, 4, 1]
Pagy::DEFAULT.freeze

require 'sinatra/base'
# Sinatra application
class PagyStandaloneApp < Sinatra::Base
  PAGY_JS = "pagy#{'-dev' if ENV['DEBUG']}.js".freeze
  configure do
    enable :inline_templates
  end
  include Pagy::Backend
  # Edit this section adding your own helpers as needed
  helpers do
    include Pagy::Frontend
  end
  # Serve pagy.js or pagy-dev.js
  get("/#{PAGY_JS}") do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', PAGY_JS)
  end
  # edit this action as needed
  get '/' do
    collection = MockCollection.new
    @pagy, @records = pagy(collection)
    erb :pagy_demo # template available in the __END__ section as @@ pagy_demo
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

run PagyStandaloneApp

__END__

@@ layout
<html>
<head>
  <meta charset="UTF-8">
  <script src="<%= %(/#{PAGY_JS}) %>"></script>
  <script type="application/javascript">
    window.addEventListener("load", Pagy.init);
  </script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio"></script>
  <style type="text/tailwindcss">
    /* If you want to customize the style,
       please replace the line below with the actual file content */
    <%= Pagy.root.join('stylesheets', 'pagy.tailwind.scss').read %>
  </style>
</head>

<body>
  <%= yield %>
</body>
</html>

@@ pagy_demo
<div class="container p-10 prose">
  <h1>Pagy Tailwind Application</h1>
  <p> Self-contained, standalone Sinatra app usable to play with pagy and/or easily reproduce any pagy issue.</p>
  <p>Please, report the following versions in any new issue.</p>
  <h4>Versions</h4>
  <ul>
    <li>Ruby: <%= RUBY_VERSION %></li>
    <li>Rack: <%= Rack::RELEASE %></li>
    <li>Sinatra: <%= Sinatra::VERSION %></li>
    <li>Pagy: <%= Pagy::VERSION %></li>
  </ul>

  <h4>Collection</h4>
  <p>@records: <%= @records.join(',') %></p>

  <hr>

  <h4>pagy_nav</h4>
  <div class="not-prose">
    <%= pagy_nav(@pagy) %>
  </div>

  <h4>pagy_nav_js</h4>
  <div class="not-prose">
    <%= pagy_nav_js(@pagy) %>
  </div>

  <h4>pagy_combo_nav_js</h4>
  <div class="not-prose">
    <%= pagy_combo_nav_js(@pagy) %>
  </div>

  <h4>pagy_items_selector_js</h4>
  <div class="not-prose">
    <%= pagy_items_selector_js(@pagy) %>
  </div>
</div>
