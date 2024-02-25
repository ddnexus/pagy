# frozen_string_literal: true

# Self-contained, standalone Sinatra app usable to play with pagy
# and/or easily reproduce any pagy issue.

# INSTALL
# Option a)
# Download, edit the gemfile block and run this file from your local copy
# Ensure rack is installed (or `gem install rack`)

# Option b)
# Clone pagy and run this file from the apps dir in the repo
# git clone --depth 1 https://github.com/ddnexus/pagy

# USAGE
#    rackup -o 0.0.0.0 -p 8080 pagy_standalone.ru

# DEV USAGE (with automatic app reload if you edit it)
# Ensure rerun is installed (or `gem install rerun`)
#    rerun -- rackup -o 0.0.0.0 -p 8080 pagy_standalone.ru

# Point your browser to http://0.0.0.0:8080

# Read the comments below to edit this app

require 'bundler/inline'

# Edit this gemfile declaration as you need
# and ensure to use gems updated to the latest versions
gemfile true do
  source 'https://rubygems.org'
  gem 'oj'
  # gem 'pagy'            # <-- install from rubygems if you copied and run it in your local
  gem 'pagy', path: '../' # <-- use the local repo if you cloned it and run it from the repo
  gem 'puma'
  gem 'rack'
  gem 'rackup'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# Edit this section adding/removing the extras and Pagy::DEFAULT as needed
# pagy initializer
require 'pagy/extras/navs'
require 'pagy/extras/items'
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:size]     = [1, 4, 4, 1]
require 'pagy/extras/trim'
Pagy::DEFAULT[:trim_extra] = false # opt-in trim (pass a trim=enabled query param)
Pagy::DEFAULT.freeze

require 'sinatra/base'
# Sinatra application
class PagyStandalone < Sinatra::Base
  PAGY_JS = "pagy#{'-dev' if ENV['DEBUG']}.js".freeze

  configure do
    enable :inline_templates
  end
  include Pagy::Backend
  # Serve pagy.js or pagy-dev.js
  get("/#{PAGY_JS}") do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', PAGY_JS)
  end
  # Edit this action as needed
  get '/:trim?' do
    collection = MockCollection.new
    @pagy, @records = pagy(collection, trim_extra: params['trim'])
    erb :pagy_demo # template available in the __END__ section as @@ pagy_demo
  end
  # Edit this section adding your own helpers as needed
  helpers do
    include Pagy::Frontend
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

run PagyStandalone

__END__

@@ layout
<html>
<head>
  <script src="<%= %(/#{PAGY_JS}) %>"></script>
  <script type="application/javascript">
    window.addEventListener("load", Pagy.init);
  </script>
  <style type="text/css">
    content {
     font-family: sans-serif;
   }
   /* If you want to customize the style,
      please replace the line below with the actual file content */
    <%= Pagy.root.join('stylesheets', 'pagy.css').read %>
  </style>
</head>

<body>
  <%= yield %>
</body>
</html>

@@ pagy_demo
<div class="content">
  <h3>Pagy App</h3>
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
  <%= pagy_nav(@pagy) %>

  <h4>pagy_nav_js</h4>
  <%= pagy_nav_js(@pagy) %>

  <h4>pagy_combo_nav_js</h4>
  <%= pagy_combo_nav_js(@pagy) %>

  <h4>pagy_items_selector_js</h4>
  <%= pagy_items_selector_js(@pagy) %>
</div>
