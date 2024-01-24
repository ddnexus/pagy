# frozen_string_literal: true

# Self-contained sinatra app to test the pagy helpers in the browser

# TEST USAGE:
#    rackup -o 0.0.0.0 -p 4567 e2e/pagy_app.ru

# DEV USAGE:
#    rerun -- rackup -o 0.0.0.0 -p 4567 e2e/pagy_app.ru

# Available at http://0.0.0.0:4567

require 'bundler'
Bundler.require(:default, :apps)
require 'oj' # require false in Gemfile

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagy'

# pagy initializer
require 'pagy/extras/calendar'  # must be loaded before the frontend extras

STYLES = %w[bootstrap bulma foundation materialize navs semantic uikit].freeze
STYLES.each { |name| require "pagy/extras/#{name}" }
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::DEFAULT[:size]       = [1, 4, 4, 1]  # old size default
Pagy::DEFAULT[:trim_extra] = false         # opt-in trim

# simple array-based collection that acts as standard DB collection
require_relative '../test/mock_helpers/collection'

# sinatra setup
require 'sinatra/base'

# sinatra application
class PagyApp < Sinatra::Base
  PAGY_JS = "pagy#{'-dev' if ENV['DEBUG']}.js".freeze

  configure do
    enable :inline_templates
  end

  include Pagy::Backend

  helpers do
    include Pagy::Frontend

    def site_map
      html = +%(<div id="site-map">| )
      [:home, *STYLES].each do |name|
        html << %(<a href="/#{name}">#{name}</a>)
        html << %(-<a href="/#{name}-calendar">cal</a>) unless name == :home
        html << %( | )
      end
      html << %(</div>)
    end
  end

  def pagy_calendar_period(collection)
    collection.minmax
  end

  def pagy_calendar_filter(collection, from, to)
    collection.select_page_of_records(from, to)  # storage in UTC
  end

  get("/#{PAGY_JS}") do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', PAGY_JS)
  end

  %w[/ /home].each do |route|
    get(route) { erb :home }
  end

  # one route/action per style
  STYLES.each do |name|
    %W[/#{name} /#{name}/:trim].each do |route|
      get(route) do
        collection = MockCollection.new
        @pagy, @records = pagy(collection, trim_extra: params['trim'])
        name_fragment = name == 'navs' ? '' : "#{name}_"
        erb :helpers, locals: { name:, name_fragment: }
      end
    end

    %W[/#{name}-calendar /#{name}-calendar/:trim].each do |route|
      get(route) do
        collection = MockCollection::Calendar.new
        @calendar, @pagy, @records = pagy_calendar(collection, month: { size: [1, 2, 2, 1],
                                                                        format: '%Y-%m',
                                                                        trim_extra: params['trim'] })
        name_fragment = name == 'navs' ? '' : "#{name}_"
        erb :calendar_helpers, locals: { name:, name_fragment: }
      end
    end
  end
end

run PagyApp

__END__

@@ layout
<html lang="en">
<head>
  <title>Pagy E2E</title>
  <script src="<%= %(/#{PAGY_JS}) %>"></script>
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
<%= send(:"pagy_#{name_fragment}nav", @pagy, pagy_id: 'nav', page_label: 'Pages nav') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %></p>
<%= send(:"pagy_#{name_fragment}nav_js", @pagy, pagy_id: 'nav-js', page_label: 'Pages nav_js') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %> (responsive)</p>
<%= send(:"pagy_#{name_fragment}nav_js", @pagy, pagy_id: 'nav-js-responsive',
         page_label: 'Pages nav_js_responsive',
         steps: { 0 => [1,3,3,1], 600 => [2,4,4,2], 900 => [3,4,4,3] }) %>
<hr>

<p><%= "pagy_#{name_fragment}combo_nav_js" %></p>
<%= send(:"pagy_#{name_fragment}combo_nav_js", @pagy, pagy_id: 'combo-nav-js', page_label: 'Pages combo_nav_js') %>
<hr>



@@ calendar_helpers
<h1 id="style"><%= name %> (calendar)</h1>
<hr>

<p>@records</p>
<div id="records"><%= @records.join(' | ') %></div>
<hr>

<p><%= "pagy_#{name_fragment}nav" %></p>
<%= send(:"pagy_#{name_fragment}nav", @calendar[:month], pagy_id: 'nav',
         page_label: 'Pages nav') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %></p>
<%= send(:"pagy_#{name_fragment}nav_js", @calendar[:month], pagy_id: 'nav-js',
         page_label: 'Pages nav_js') %>
<hr>

<p><%= "pagy_#{name_fragment}nav_js" %> (responsive)</p>
<%= send(:"pagy_#{name_fragment}nav_js", @calendar[:month], pagy_id: 'nav-js-responsive',
         page_label: 'Pages combo_nav_js',
         steps: { 0 => [1,3,3,1], 600 => [2,4,4,2], 900 => [3,4,4,3] }) %>
<hr>
