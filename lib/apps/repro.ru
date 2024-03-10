# frozen_string_literal: true

# Self-contained, standalone Sinatra app usable to play with pagy
# and/or easily reproduce any pagy issue.

# USAGE
# To reproduce some issue:
#    pagy create repro
#    pagy develop ./repro.ru
# ...point your browser to http://0.0.0.0:8000
# Edit something in the "repro.ru" just created in your current dir and it will
# be automatically restarted, so you can reload your browser page and see the effect

# HELP:
#    pagy help

require 'bundler/inline'
gemfile true do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'puma'
  gem 'rouge'
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
Pagy::DEFAULT.freeze

require 'sinatra/base'
# Sinatra application
class PagyRepro < Sinatra::Base
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
  get '/' do
    collection = MockCollection.new
    @pagy, @records = pagy(collection)
    erb :main # template available in the __END__ section as @@ main
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

run PagyRepro

__END__

@@ layout
<!DOCTYPE html>
<html lang="en">
<html>
<head>
  <script src="<%= %(/#{PAGY_JS}) %>"></script>
  <script type="application/javascript">
    window.addEventListener("load", Pagy.init);
  </script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style type="text/css">
    @media screen { html, body {
      font-size: 1rem;
      line-heigth: 1.2s;
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
    <%= Pagy.root.join('stylesheets', 'pagy.css').read %>
  </style>
</head>

<body>
  <%= yield %>
</body>
</html>

@@ main
<div class="content">
  <h3>Pagy Repro App</h3>
  <p> Self-contained, standalone Sinatra app usable toss easily reproduce any pagy issue.</p>
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

  <h4>pagy_info</h4>
  <%= pagy_info(@pagy) %>
</div>
