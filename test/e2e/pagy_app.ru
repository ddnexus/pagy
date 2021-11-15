# frozen_string_literal: true

# Self-contained sinatra app to test the pagy helpers in the browser

# TEST USAGE:
#    rackup -o 0.0.0.0 -p 4567 test/e2e/pagy_app.ru

# DEV USAGE:
#    rerun -- rackup -o 0.0.0.0 -p 4567 test/e2e/pagy_app.ru

# Available at http://0.0.0.0:4567

require 'bundler'
Bundler.require(:default, :apps)
require 'oj' # require false in Gemfile

$LOAD_PATH.unshift File.expand_path('../../lib', __dir__)
require 'pagy'

# pagy initializer
require 'pagy/extras/calendar'  # must be loaded before the frontend extras

STYLES = %w[bootstrap bulma foundation materialize navs semantic uikit].freeze
STYLES.each { |name| require "pagy/extras/#{name}" }
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::DEFAULT[:trim_extra] = false  # opt-in trim

# simple array-based collection that acts as standard DB collection
require_relative '../mock_helpers/collection'

# sinatra setup
require 'sinatra/base'

# sinatra application
class PagyApp < Sinatra::Base
  configure do
    enable :inline_templates
  end

  include Pagy::Backend

  helpers do
    include Pagy::Frontend

    def site_map
      html = +%(<div id="site-map">| )
      query_string = "?#{Rack::Utils.build_nested_query(params)}" unless params.empty?
      [:home, *STYLES].each do |name|
        html << %(<a href="/#{name}#{query_string}">#{name}</a>)
        html << %(-<a href="/#{name}-calendar#{query_string}">cal</a>) unless name == :home
        html << %( | )
      end
      html << %(</div>)
    end
  end

  # Override the super method in order to set the minmax array dynamically
  def pagy_calendar_minmax(collection)
    collection.minmax.map { |t| t.getlocal(0) }  # 0 utc_offset means 00:00 local time
  end

  # Implemented by the user: use pagy.utc_from, pagy.utc_to to get the page records from your collection
  # Our collection time is stored in UTC, so we don't need to convert the time provided by utc_from/utc_to
  def pagy_calendar_filtered(collection, utc_from, utc_to)
    collection.select_page_of_records(utc_from, utc_to)
  end

  get '/pagy.js' do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', 'pagy.js')
  end

  %w[/ /home].each do |route|
    get(route) { erb :home }
  end

  # one route/action per style
  STYLES.each do |name|
    get "/#{name}" do
      collection = MockCollection.new
      @pagy, @records = pagy(collection)
      name_fragment = name == 'navs' ? '' : "#{name}_"
      erb :helpers, locals: { name: name, name_fragment: name_fragment }
    end

    get "/#{name}-calendar" do
      collection = MockCollection::Calendar.new
      @calendar, @pagy, @records = pagy_calendar(collection, month: { size: [1, 2, 2, 1] })
      name_fragment = name == 'navs' ? '' : "#{name}_"
      erb :calendar_helpers, locals: { name: name, name_fragment: name_fragment }
    end
  end
end

run PagyApp

__END__

@@ layout
<html lang="en">
<head>
  <title>Pagy E2E</title>
  <script src="/pagy.js"></script>
  <script>
    window.addEventListener("load", Pagy.init);
  </script>
  <link rel="stylesheet" href="/normalize-styles.css">
</head>
<body>
  <%= yield %>
  <%= site_map %>
</body>
</html>



@@ home
<div id="home">
  <h1>Pagy e2e app</h1>

  <p>This app runs on Sinatra/Puma and is used for testing locally and in GitHub Actions CI with cypress, or just inspect the different helpers in the same page.</p>

  <p>It shows all the helpers for all the styles supported by pagy.</p>

  <p>Each framework provides its own set of CSS that applies to the helpers, but we cannot load different frameworks in the same app because they would conflict. Without the framework where the helpers are supposed to work we can only normalize the CSS styles in order to make them at least readable.</p>
  <hr>
</div>



@@ helpers
<h1 id="style"><%= name %></h1>
<hr>

<p>@records</p>
<p id="records"><%= @records.join(',') %></p>
<hr>

<p>pagy_info</p>
<%= pagy_info(@pagy, pagy_id: 'pagy-info') %>
<hr>

<p>pagy_items_selector_js</p>
<%= pagy_items_selector_js(@pagy, pagy_id: 'items-selector-js') %>
<hr>

<p><%= "pagy_#{name_fragment}nav" %></p>
<%= send(:"pagy_#{name_fragment}nav", @pagy, pagy_id: 'nav') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %></p>
<%= send(:"pagy_#{name_fragment}nav_js", @pagy, pagy_id: 'nav-js') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %> (responsive)</p>
<%= send(:"pagy_#{name_fragment}nav_js", @pagy, pagy_id: 'nav-js-responsive', steps: { 0 => [1,3,3,1], 600 => [2,4,4,2], 900 => [3,4,4,3] }) %>
<hr>

<p><%= "pagy_#{name_fragment}combo_nav_js" %></p>
<%= send(:"pagy_#{name_fragment}combo_nav_js", @pagy, pagy_id: 'combo-nav-js') %>
<hr>



@@ calendar_helpers
<h1 id="style"><%= name %> (calendar)</h1>
<hr>

<p>@records</p>
<div id="records"><%= @records.join(' | ') %></div>
<hr>

<p><%= "pagy_#{name_fragment}nav" %></p>
<%= send(:"pagy_#{name_fragment}nav", @calendar[:month], pagy_id: 'nav') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %></p>
<%= send(:"pagy_#{name_fragment}nav_js", @calendar[:month], pagy_id: 'nav-js') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %> (responsive)</p>
<%= send(:"pagy_#{name_fragment}nav_js", @calendar[:month], pagy_id: 'nav-js-responsive', steps: { 0 => [1,3,3,1], 600 => [2,4,4,2], 900 => [3,4,4,3] }) %>
<hr>
