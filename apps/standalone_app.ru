# frozen_string_literal: true

# Self-contained sinatra app usable to easily reproduce any pagy issue

# USAGE: rerun -- rackup -o 0.0.0.0 -p 8080 apps/basic_app.ru

# Available at http://0.0.0.0:8080

require "bundler/inline"

# edit this gemfile declaration as you need
# and ensure to use gems updated to the latest versions
gemfile true do
  source "https://rubygems.org"
  gem 'oj'
  gem 'rack'
  gem 'rake'
  gem 'pagy'
  gem 'rerun'
  gem 'puma'
  gem 'sinatra'
  gem 'sinatra-contrib'
end
puts "Pagy::VERSION: #{Pagy::VERSION}"

# edit this section adding/removing the extras and Pagy::VARS as you need
# pagy initializer
require 'pagy/extras/navs'
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::VARS[:trim] = false # opt-in trim

# sinatra setup
require 'sinatra/base'

class PagyApp < Sinatra::Base

  # sinatra application
  enable :inline_templates

  include Pagy::Backend   # rubocop:disable Style/MixinUsage
  # edit this section adding your own helpers as you need
  helpers do
    include Pagy::Frontend
  end

  get '/pagy.js' do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', 'pagy.js')
  end

  get '/' do
    erb :welcome
  end

  # edit this action as you need
  get '/pagy_issue' do
    collection = MockCollection.new
    @pagy, @records = pagy(collection)
    erb :pagy_issue    # template available in the __END__ section as @@ pagy_issue
  end
end

# simple array-based collection that acts as standard DB collection
# use it as a simple way to get a collection that acts as a AR scope, but without any DB
# Or use ActiveRecord if you prefer
class MockCollection < Array
  def initialize(arr=Array(1..1000))
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

run PagyApp

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


@@ welcome
<h3>Pagy app</h3>
<p>This app runs on Sinatra/Puma</p>


@@ pagy_issue
<h3>Edit this view as you need</h3>
<p>@records</p>
<p><%= @records.join(',') %></p>
<br>
<%= pagy_nav(@pagy) %>
<br>
<%= pagy_nav_js(@pagy) %>
<br>
<%= pagy_combo_nav_js(@pagy) %>
<br>
<%= pagy_items_selector_js(@pagy) %>
