# frozen_string_literal: true

# Basic self-contained rack/sinatra app
# edit or duplicate this app to experiment with the pagy features

# USAGE: rerun -- rackup -o 0.0.0.0 -p 8080 apps/basic_app.ru

Bundler.require(:default, :apps)
require 'oj' # require false in Gemfile

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagy'

# pagy initializer
require 'pagy/extras/navs'
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::VARS[:trim] = false # opt-in trim

# sinatra setup
require 'sinatra/base'

# simple array-based collection that acts as standard DB collection
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

# sinatra application
class PagyApp < Sinatra::Base

  configure do
    enable :inline_templates
  end

  include Pagy::Backend

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

  get '/helpers' do
    collection = MockCollection.new
    @pagy, = pagy(collection)
    erb :helpers
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
<h3>Pagy test_js app</h3>
<p>This app runs on Sinatra/rackup/Puma</p>


@@ helpers
<br>
<%= pagy_nav(@pagy) %>
<br>
<%= pagy_nav_js(@pagy) %>
<br>
<%= pagy_combo_nav_js(@pagy) %>
<br>
<%= pagy_items_selector_js(@pagy) %>
