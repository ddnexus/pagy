# frozen_string_literal: true

# DESCRIPTION
#    Screenshot tool for the pagy docs.
#
# DEV USAGE
#    pagy docshots
#
# URL
#    http://127.0.0.1:8000

VERSION = '10.0.0'

if VERSION != Pagy::VERSION
  Warning.warn("\n>>> WARNING! '#{File.basename(__FILE__)}-#{VERSION}' running with 'pagy-#{Pagy::VERSION}'! <<< \n\n")
end
run_from_repo = Pagy::ROOT.join('pagy.gemspec').exist?

# Bundle
require 'bundler/inline'
gemfile(!run_from_repo) do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'puma'
  gem 'sinatra'
end

# Edit this section adding the legacy as needed
# Pagy initializer
Pagy.options[:client_max_limit] = 100

# Sinatra setup
require 'sinatra/base'
# Sinatra application
class PagyDocshots < Sinatra::Base
  include Pagy::Method

  get('/javascript/:file') do
    format = params[:file].split('.').last
    if format == 'js'
      content_type 'application/javascript'
    elsif format == 'map'
      content_type 'application/json'
    end
    send_file Pagy::ROOT.join('javascript', params[:file])
  end

  get('/stylesheet/:file') do
    content_type 'text/css'
    send_file Pagy::ROOT.join('stylesheet', params[:file])
  end

  get '/:style' do
    collection      = MockCollection.new
    @pagy, @records = pagy(:offset, collection)
    classes         = { 'bootstrap' => 'pagination pagination-sm',
                        'bulma' => 'pagination is-small' }[params[:style]]
    erb :main, locals: { classes:, **params }
  end

  get '/' do
    redirect '/pagy'
  end

  helpers do
    def head_for(style)
      case style  # rubocop:disable Style/HashLikeCase
      when 'pagy'
        %(<link rel="stylesheet" href="/stylesheet/pagy.css">)
      when 'bootstrap'
        %(<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">)
      when 'bulma'
        %(<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">)
      end
    end
  end
  # Views
  template :layout do
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <html>
      <head>
        <title>Pagy Docshots</title>
        <script src="javascript/pagy.js"></script>
        <script>
          window.addEventListener("load", Pagy.init);
        </script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <%= head_for(style) %>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&display=swap" rel="stylesheet">
        <style>
          @media screen { html, body {
            font-size: 1rem;
            line-height: 1.2;
            padding: 0;
            margin: 0;
          } }
          html {
            background-color: transparent !important;
          }
          body {
            margin: 0 !important;
            font-family: "Nunito Sans", sans-serif;
            color: #303030 !important;
            background-color: transparent !important;
          }
          .main-content {
            padding: 1rem 1.5rem 2rem !important;
          }
          .backdrop {
            padding: .5em;
            margin: .3em 0;
            width: fit-content;
            box-shadow: 8px 8px 18px 0px rgba(0,0,0,0.25);*/
          }
          .pagy-bootstrap .pagination {
            margin: 0;
          }
          .pagy-bulma a:not(.is-current),
          .pagy-bulma li.pagination-link {
            background-color: white !important;
          }
        </style>
        <style>
          h1 {
            font-size: 2rem;
            font-weight: bold;
          }
          h4 {
            font-size: 1rem;
            font-weight: bold;
            margin-bottom: 1rem;
          }
          #links {
            padding-top: 1rem;
          }
          #links a {
            color: black;
            text-decoration: none;
          }
          #links a.session-visited {
            text-decoration: none;
            color: green;
          }
        </style>
      </head>
      <body>
        <div class="main-content">
          <h1>Pagy Docshots</h1>
          <p>Screenshot tool for the pagy docs.</p>
          <hr>
          <%= yield %>
        </div>
      </body>
      </html>
    HTML
  end

  template :main do
    <<~ERB
      <div id="target">
      <% case (meth ||= 'anchor_tags').to_sym %>
      <% when :anchor_tags %>
         <h4 class="filename">pagy-anchor_tags.png</h4>
         <div class="backdrop">
           <nav class="pagy" id="anchor-tags" aria-label="anchor-tags"><%= @pagy.previous_tag + ' ' + @pagy.next_tag %></nav>
         </div>
      <% when :limit_tag_js %>
        <h4 class="filename">pagy-limit_tag_js.png</h4>
        <div class="backdrop">
          <%= @pagy.limit_tag_js(id: 'limit-tag-js') %>
        </div>
      <% when :series_nav %>
        <h4 class="filename"><%= style %>-series_nav.png</h4>
        <div class="backdrop">
          <%= @pagy.series_nav(style, classes:,
                               id: 'series-nav',
                               aria_label: 'series-nav') %>
        </div>
      <% when :series_nav_js %>
        <h4 class="filename"><%= style %>-series_nav_js-<%= slots %>.png</h4>
        <div class="backdrop">
          <%= @pagy.series_nav_js(style, classes:,
                                  id: 'series-nav-js',
                                  aria_label: 'series-nav-js',
                                  steps: { 0 => slots.to_i }) %>
        </div>
      <% when :input_nav_js %>
        <h4 class="filename"><%= style %>-input_nav_js.png</h4>
        <div class="backdrop">
          <%= @pagy.input_nav_js(style, classes:,
                                 id: 'input-nav-js',
                                 aria_label: 'input-nav-js') %>
        </div>
        <% end %>
      </div>
      <div id="links">
        <hr><br>
        <a href="/pagy?meth=anchor_tags">pagy-anchor_tags.png</a></br>
        <a href="/pagy?meth=limit_tag_js">pagy-limit_tag_js.png</a></br>

        <% %w[pagy bootstrap bulma].each do |style| %>
        <a href="/<%= style %>?meth=series_nav"><%= style %>-series_nav.png</a></br>
        <a href="/<%= style %>?meth=series_nav_js&slots=7&page=11"><%= style %>-series_nav_js-7.png</a></br>
        <a href="/<%= style %>?meth=series_nav_js&slots=9&page=11"><%= style %>-series_nav_js-9.png</a></br>
        <a href="/<%= style %>?meth=series_nav_js&slots=11&page=11"><%= style %>-series_nav_js-11.png</a></br>
        <a href="/<%= style %>?meth=input_nav_js&page=11"><%= style %>-input_nav_js.png</a></br>
        <br>
        <% end %>
      </div>
    ERB
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

run PagyDocshots
