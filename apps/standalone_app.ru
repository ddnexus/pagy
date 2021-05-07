# frozen_string_literal: true

# Self-contained, standalone sinatra app usable to easily reproduce any pagy issue

# USAGE: rerun -- rackup -o 0.0.0.0 -p 8080 apps/basic_app.ru

# Available at http://0.0.0.0:8080

require 'bundler/inline'

# edit this gemfile declaration as you need
# and ensure to use gems updated to the latest versions
gemfile true do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'rack'
  gem 'pagy'
  gem 'rerun'
  gem 'puma'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# edit this section adding/removing the extras and Pagy::VARS as needed
# pagy initializer
require 'pagy/extras/navs'
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::VARS[:trim] = false # opt-in trim

# sinatra setup
require 'sinatra/base'

# sinatra application
class PagyApp < Sinatra::Base

  configure do
    enable :inline_templates
  end

  include Pagy::Backend

  # edit this section adding your own helpers as you need
  helpers do
    include Pagy::Frontend
  end

  get '/pagy.js' do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', 'pagy.js')
  end

  # edit this action as you need
  get '/' do
    collection = MockCollection.new
    @pagy, @records = pagy(collection)
    erb :pagy_demo    # template available in the __END__ section as @@ pagy_issue
  end

end

# simple array-based collection that acts as standard DB collection
# use it as a simple way to get a collection that acts as a AR scope, but without any DB
# or create an ActiveRecord class or anything else that you need instead
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


@@ pagy_demo
<h3>Pagy Standalone</h3>
<p> Self-contained, standalone sinatra app usable to easily reproduce any pagy issue.</p>
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
