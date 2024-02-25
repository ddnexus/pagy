# frozen_string_literal: true

# Self-contained sinatra app to play with the pagy styles in the browser

# INSTALL
# Option a)
# Download, edit the gemfile block and run this file from your local copy
# Ensure rack is installed (or `gem install rack`)

# Option b)
# Clone pagy and run this file from the apps dir in the repo
# git clone --depth 1 https://github.com/ddnexus/pagy

# USAGE
#    rackup -o 0.0.0.0 -p 8080 pagy_styles.ru

# DEV USAGE (with automatic app reload if you edit it)
# Ensure rerun is installed (or `gem install rerun`)
#    rerun -- rackup -o 0.0.0.0 -p 8080 pagy_styles.ru

# Available at http://0.0.0.0:8080

require 'bundler/inline'

# Edit this gemfile declaration as you need
# and ensure to use gems updated to the latest versions
gemfile true do
  source 'https://rubygems.org'
  gem 'oj'
  # gem 'pagy'            # <-- install from rubygems if you copied and run it in your local
  gem 'pagy', path: '../' # <-- use the local repo if you cloned it and run it from the repo
  gem 'puma'
  gem 'rack'
  gem 'rackup'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# pagy initializer
STYLES = { pagy:      { extra: 'navs', prefix: '' },
           bootstrap: {},
           tailwind:  { extra: 'navs', prefix: '' } }.freeze

STYLES.each_key do |style|
  require "pagy/extras/#{STYLES[style][:extra] || style}"
end
require 'pagy/extras/items'
require 'pagy/extras/trim'
Pagy::DEFAULT[:size]       = [1, 4, 4, 1]  # old size default
Pagy::DEFAULT[:trim_extra] = false         # opt-in trim

# sinatra setup
require 'sinatra/base'

# sinatra application
class PagyStyles < Sinatra::Base
  configure do
    enable :inline_templates
  end

  include Pagy::Backend

  get '/' do
    redirect '/pagy'
  end

  get('/javascripts/:file') do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', params['file'])
  end

  get('/stylesheets/:file') do
    content_type 'text/css'
    send_file Pagy.root.join('stylesheets', params['file'])
  end

  # one route/action per style
  STYLES.each_key do |style|
    prefix = STYLES[style][:prefix] || "#{style}_"

    %W[/#{style} /#{style}/:trim].each do |route|
      get(route) do
        collection = MockCollection.new
        @pagy, @records = pagy(collection, trim_extra: params['trim'])

        erb :helpers, locals: { style:, prefix: }
      end
    end
  end

  helpers do
    include Pagy::Frontend

    def styles_menu
      html = +%(<div id="site-map"> )
      html << STYLES.keys.map { |style| %(<a href="/#{style}">#{style}</a>) }.join(' | ')
      html << %(</div>)
    end
  end
end

# Simple array-based collection that acts as a standard DB collection.
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

run PagyStyles

__END__

@@ layout
<html lang="en">
<head>
  <title>Pagy Styles</title>
  <script src="<%= %(/javascripts/#{"pagy#{'-dev' if ENV['DEBUG']}.js"}) %>"></script>
  <script>
    window.addEventListener("load", Pagy.init);
  </script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style type="text/css">
    .content {
      padding: 0 .5rem;
      font-family: sans-serif;
    }
  </style>
  <%= erb :"#{style}_head" if defined?(style) %>
</head>
<body>
<!-- each different class used by each style -->
<div class="content prose max-w-none">
  <%= styles_menu %>
  <%= yield %>
<div>
</body>
</html>


@@ pagy_head
<link rel="stylesheet" href="/stylesheets/pagy.css">

@@ bootstrap_head
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

@@ tailwind_head
<script src="https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio"></script>
<style type="text/tailwindcss">
  <%= Pagy.root.join('stylesheets', 'pagy.tailwind.scss').read %>
</style>


@@ helpers
<h1><%= style %></h1>

<h4>Collection</h4>
<p>@records: <%= @records.join(',') %></p>

<h4>pagy_nav</h4>
<div class="not-prose">
  <%= send(:"pagy_#{prefix}nav", @pagy, pagy_id: 'nav', nav_aria_label: 'Pages nav') %>
</div>

<h4>pagy_nav_js</h4>
<div class="not-prose">
  <%= send(:"pagy_#{prefix}nav_js", @pagy, pagy_id: 'nav-js', nav_aria_label: 'Pages nav_js') %>
</div>

<h4>pagy_nav_js (responsive)</h4>
<div class="not-prose">
  <%= send(:"pagy_#{prefix}nav_js", @pagy, pagy_id: 'nav-js-responsive',
       nav_aria_label: 'Pages nav_js_responsive',
       steps: { 0 => [1,3,3,1], 600 => [2,4,4,2], 900 => [3,4,4,3] }) %>
</div>

<h4>pagy_combo_nav_js</h4>
<div class="not-prose">
  <%= send(:"pagy_#{prefix}combo_nav_js", @pagy, pagy_id: 'combo-nav-js', nav_aria_label: 'Pages combo_nav_js') %>
</div>

<h4>pagy_items_selector_js</h4>
<div class="not-prose">
  <%= pagy_items_selector_js(@pagy, pagy_id: 'items-selector-js') %>
</div>

<h4>pagy_info</h4>
<div class="not-prose">
  <%= pagy_info(@pagy, pagy_id: 'pagy-info') %>
</div>


@@ calendar_helpers
<h1 id="style"><%= style %> (calendar)</h1>
<hr>

<p>@records</p>
<div id="records"><%= @records.join(' | ') %></div>
<hr>

<p><%= "pagy_#{prefix}nav" %></p>
<%= send(:"pagy_#{prefix}nav", @calendar[:month], pagy_id: 'nav',
         nav_aria_label: 'Pages nav') %>
<hr>

<p><%= "pagy_#{prefix}nav_js" %></p>
<%= send(:"pagy_#{prefix}nav_js", @calendar[:month], pagy_id: 'nav-js',
         nav_aria_label: 'Pages nav_js') %>
<hr>

<p><%= "pagy_#{prefix}nav_js" %> (responsive)</p>
<%= send(:"pagy_#{prefix}nav_js", @calendar[:month], pagy_id: 'nav-js-responsive',
         nav_aria_label: 'Pages combo_nav_js',
         steps: { 0 => [1,3,3,1], 600 => [2,4,4,2], 900 => [3,4,4,3] }) %>
<hr>
