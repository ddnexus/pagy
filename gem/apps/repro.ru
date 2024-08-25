# frozen_string_literal: true

# Starting point app to try pagy or reproduce issues

# DEV USAGE
#    pagy clone repro
#    pagy ./repro.ru

# URL
#    http://0.0.0.0:8000

# HELP
#    pagy -h

# DOC
#    https://ddnexus.github.io/pagy/playground/#1-repro-app

VERSION = '9.0.6'

require 'bundler/inline'
require 'bundler'
Bundler.configure
gemfile(ENV['PAGY_INSTALL_BUNDLE'] == 'true') do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'puma'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# Edit this section adding/removing the extras and Pagy::DEFAULT as needed
# pagy initializer
require 'pagy/extras/pagy'
require 'pagy/extras/limit'
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT.freeze

require 'sinatra/base'
# Sinatra application
class PagyRepro < Sinatra::Base
  configure do
    enable :inline_templates
  end
  include Pagy::Backend

  get('/javascripts/:file') do
    format = params[:file].split('.').last
    if format == 'js'
      content_type 'application/javascript'
    elsif format == 'map'
      content_type 'application/json'
    end
    send_file Pagy.root.join('javascripts', params[:file])
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
   <title>Pagy Repro App</title>
  <script src="javascripts/pagy.min.js"></script>
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
    <%= Pagy.root.join('stylesheets', 'pagy.css').read %>
  </style>
</head>
<body>
  <%= yield %>
</body>
</html>

@@ main
<div class="content">
  <h1>Pagy Repro App</h1>
  <p> Self-contained, standalone Sinatra app usable to easily reproduce any pagy issue.</p>
  <p>Please, report the following versions in any new issue.</p>
  <h2>Versions</h4>
  <ul>
    <li>Ruby: <%= RUBY_VERSION %></li>
    <li>Rack: <%= Rack::RELEASE %></li>
    <li>Sinatra: <%= Sinatra::VERSION %></li>
    <li>Pagy: <%= Pagy::VERSION %></li>
  </ul>

  <h3>Collection</h3>
  <p id="records">@records: <%= @records.join(',') %></p>

  <hr>

  <h4>pagy_nav</h4>
  <%= pagy_nav(@pagy, id: 'nav', aria_label: 'Pages nav') %>

  <h4>pagy_nav_js</h4>
  <%= pagy_nav_js(@pagy, id: 'nav-js', aria_label: 'Pages nav_js') %>

  <h4>pagy_nav_js</h4>
  <%= pagy_nav_js(@pagy, id: 'nav-js-responsive', aria_label: 'Pages nav_js_responsove',
     steps: { 0 => 5, 500 => 7, 750 => 9, 1000 => 11 }) %>

  <h4>pagy_combo_nav_js</h4>
  <%= pagy_combo_nav_js(@pagy, id: 'combo-nav-js', aria_label: 'Pages combo_nav_js') %>

  <h4>pagy_limit_selector_js</h4>
  <%= pagy_limit_selector_js(@pagy, id: 'limit-selector-js') %>

  <h4>pagy_info</h4>
  <%= pagy_info(@pagy, id: 'pagy-info') %>
</div>
