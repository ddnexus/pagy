# frozen_string_literal: true

# Self-contained sinatra app to test the js helpers

# USAGE:
#    test_js/test_app.rb -o 0.0.0.0

# DEV USAGE:
#    rerun "test_js/test_app.rb -o 0.0.0.0"

# Available at http://0.0.0.0:4567

require 'bundler'
Bundler.require(:default, :apps)
require 'oj' # require false in Gemfile

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'pagy'

# pagy initializer
FRAMEWORKS=%w[bootstrap bulma foundation materialize navs semantic uikit].freeze
FRAMEWORKS.each { |name| require "pagy/extras/#{name}" }
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::VARS[:trim] = false  # opt-in trim

# simple array-based collection that acts as standard DB collection
require_relative '../test/mock_helpers/collection'

# sinatra setup
require 'sinatra'

# sinatra application
enable :inline_templates

include Pagy::Backend   # rubocop:disable Style/MixinUsage

helpers do
  include Pagy::Frontend

  def framework_links
    html = +%(<div class="framework-links">)
    query_string = "?#{Rack::Utils.build_nested_query(params)}" unless params.empty?
    [ :home, *FRAMEWORKS].each do |name|
      html << %(<a href="#{name}#{query_string}">#{name}</a> )
    end
    html << %(</div>)
  end

end

# routes/actions

get '/pagy.js' do
  content_type 'application/javascript'
  send_file Pagy.root.join('javascripts', 'pagy.js')
end

%w[/ /home].each do |route|
  get(route) { erb :home }
end

# one route/action per framework
FRAMEWORKS.each do |name|
  get "/#{name}" do
    collection = MockCollection.new
    @pagy, @records = pagy(collection)
    name_fragment = name == 'navs' ? '' : "#{name}_"
    erb :js_helpers, locals: {name: name, name_fragment: name_fragment}
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
  <link rel="stylesheet" href="normalize-frameworks.css"
</head>
<body>
  <%= yield %>
  <%= framework_links %>
</body>
</html>



@@ home
<h3>Pagy test_js app</h3>

<p>This app runs on Sinatra/Puma and is used for testing JS locally and in GitHub Actions CI, or just inspect the different helpers in the same page.</p>

<p>It shows all the javascript helpers for all the frameworks supported by pagy, plus the helpers provided by the unstyled "navs" extra.</p>

<p>Each framework provides its own set of CSS that applies to the helpers, but we cannot load different framewors in the same app because they would conflict. Without the framework where the helpers are supposed to work we can only normalize the CSS styles in order to make them at least readable.</p>
<hr>



@@ js_helpers
<div class="js-helpers">
  <h3><%= name %></h3>
  <hr>

  <p>@records</p>
  <p><%= @records.join(',') %></p>
  <hr>

  <p>pagy_info</p>
  <%= pagy_info(@pagy) %>
  <hr>

  <p>pagy_items_selector_js</p>
  <%= pagy_items_selector_js(@pagy) %>
  <hr>

  <p><%= "pagy_#{name_fragment}nav_js" %></p>
  <%= send :"pagy_#{name_fragment}nav_js", @pagy %>
  <hr>

  <p><%= "pagy_#{name_fragment}nav_js" %> (responsive)</p>
  <div class="responsive">
    <%= send :"pagy_#{name_fragment}nav_js", @pagy, steps: { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] } %>
  </div>

  <hr>
  <p><%= "pagy_#{name_fragment}combo_nav_js" %></p>
  <%= send :"pagy_#{name_fragment}combo_nav_js", @pagy %>
  <hr>
</div>
