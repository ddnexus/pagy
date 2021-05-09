# frozen_string_literal: true

# Self-contained sinatra app to test the pagy helpers in the browser

# USAGE:
#    test/e2e/app.rb -o 0.0.0.0

# DEV USAGE:
#    rerun "test/e2e/app.rb -o 0.0.0.0"

# Available at http://0.0.0.0:4567

require 'bundler'
Bundler.require(:default, :apps)
require 'oj' # require false in Gemfile

$LOAD_PATH.unshift File.expand_path('../../lib', __dir__)
require 'pagy'

# pagy initializer
STYLES=%w[bootstrap bulma foundation materialize navs semantic uikit].freeze
STYLES.each { |name| require "pagy/extras/#{name}" }
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::VARS[:trim] = false  # opt-in trim

# simple array-based collection that acts as standard DB collection
require_relative '../mock_helpers/collection'

# sinatra setup
require 'sinatra'

# sinatra application
enable :inline_templates

include Pagy::Backend   # rubocop:disable Style/MixinUsage

helpers do
  include Pagy::Frontend

  def site_map
    html = +%(<div id="site-map">)
    query_string = "?#{Rack::Utils.build_nested_query(params)}" unless params.empty?
    [:home, *STYLES].each do |name|
      html << %(<a href="/#{name}#{query_string}">#{name}</a> )
    end
    html << %(</div>)
  end

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
    erb :helpers, locals: {name: name, name_fragment: name_fragment}
  end
end


__END__

@@ layout
<html>
<head>
  <script type="application/javascript" src="/pagy.js"></script>
  <script type="application/javascript">
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
  <h3>Pagy e2e app</h3>

  <p>This app runs on Sinatra/Puma and is used for testing locally and in GitHub Actions CI with cypress, or just inspect the different helpers in the same page.</p>

  <p>It shows all the helpers for all the styles supported by pagy.</p>

  <p>Each framework provides its own set of CSS that applies to the helpers, but we cannot load different framewors in the same app because they would conflict. Without the framework where the helpers are supposed to work we can only normalize the CSS styles in order to make them at least readable.</p>
  <hr>
</div>



@@ helpers
<h3 id="style"><%= name %></h3>
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
