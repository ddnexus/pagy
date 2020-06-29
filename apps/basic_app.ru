# Basec self-contained rack/sinatra app
# edit or duplicate this app to experiment with the pagy features

# USAGE: rackup -I lib -o 0.0.0.0 -p 8080 apps/basic_app.ru

# standard bundler using project Gemfile
require 'rubygems'
require 'bundler'
Bundler.require(:default, :apps)

require 'pagy'

# pagy initializer
require 'pagy/extras/navs'
require 'pagy/extras/items'
require 'pagy/extras/trim' if ENV['ENABLE_TRIM']
require 'oj' if ENV['ENABLE_OJ']

# sinatra setup
require "sinatra/base"
require "sinatra/reloader"


# simple array-based collection that acts as standard DB collection
class MockCollection < Array

  def initialize(arr=Array(1..1000))
    super
    @collection = self.clone
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

# sinatra application
class PagyApp < Sinatra::Base

  configure do
    enable :inline_templates
  end

  configure :development do
    register Sinatra::Reloader
  end

  include Pagy::Backend
  include Pagy::Frontend

  get '/pagy.js' do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', 'pagy.js')
  end

  get '/' do
    redirect '/helpers'
  end

  get '/helpers' do
    collection = MockCollection.new
    @pagy, _   = pagy(collection)
    erb :helpers
  end

  get '/no-pagy' do
    erb :'no-pagy'
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

@@ helpers
<br>
<%= pagy_nav(@pagy) %>
<br>
<%= pagy_nav_js(@pagy) %>
<br>
<%= pagy_combo_nav_js(@pagy) %>
<br>
<%= pagy_items_selector_js(@pagy) %>

@@ no-pagy
<p>Just a page without pagy</p>
