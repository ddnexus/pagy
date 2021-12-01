# frozen_string_literal: true

# Self-contained, standalone Sinatra app usable to play with pagy
# and/or easily reproduce any pagy issue.

# Copy this file in your own machine and
# ensure rack is installed (or `gem install rack`)
# or run it from the apps dir in the repo

# USAGE:
#    rackup -o 0.0.0.0 -p 8080 pagy_standalone_app.ru

# ADVANCED USAGE (with automatic app reload if you edit it):
#    gem install rerun
#    rerun -- rackup -o 0.0.0.0 -p 8080 pagy_standalone_app.ru

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
# Pagy::DEFAULT[:items_extra]
require 'pagy/extras/trim'
Pagy::DEFAULT[:trim_extra] = false # opt-in trim

require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :empty_page

# require 'pagy/extras/gearbox'
# Pagy::DEFAULT[:gearbox_items] = [10, 20, 40, 80]
Pagy::DEFAULT.freeze

require 'sinatra/base'
# Sinatra application
class PagyStandaloneApp < Sinatra::Base
  configure do
    enable :inline_templates
  end
  include Pagy::Backend
  # Edit this section adding your own helpers as needed
  helpers do
    include Pagy::Frontend
  end
  get '/pagy.js' do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', 'pagy.js')
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
    @collection = self[value..-1]
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
  <script type="application/javascript" src="/pagy.js"></script>
  <script type="application/javascript">
    window.addEventListener("load", Pagy.init);
  </script>
</head>
<body>
  <%= yield %>
</body>
</html>

@@ pagy_demo
<h3>Pagy Standalone Application</h3>
<p> Self-contained, standalone Sinatra app usable to play with pagy and/or easily reproduce any pagy issue.</p>
<p>Please, report the following versions in any new issue.</p>
<h4>Versions</h4>
<ul>
  <li>Ruby: <%= RUBY_VERSION %></li>
  <li>Rack: <%= Rack::RELEASE %></li>
  <li>Sinatra: <%= Sinatra::VERSION %></li>
  <li>Pagy: <%= Pagy::VERSION %></li>
</ul>
<hr>
<h4>Pagy Helpers</h4>
<p>@records: <%= @records.join(',') %></p>
<br>
<%= pagy_nav(@pagy) %>
<br>
<%= pagy_nav_js(@pagy) %>
<br>
<%= pagy_combo_nav_js(@pagy) %>
<br>
<%= pagy_items_selector_js(@pagy) %>
