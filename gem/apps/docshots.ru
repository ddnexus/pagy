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
      case style
      when 'pagy'
        %(<link rel="stylesheet" href="/stylesheet/pagy.css">
          <style>
            /* black/white backdrop color based on --B */
            .pagy { background-color: hsl(0 0 calc(100 * var(--B))) !important; }
          </style>)
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
          window.addEventListener("load", function() {
            const textToCopy = document.querySelector('.main-content h4:first-of-type').textContent;
            navigator.clipboard.writeText(textToCopy).then(() => {
                console.log('Text copied:', textToCopy);
              }).catch(err => {
                console.error('Failed to copy text: ', err);
              });
            });
          // Link tracking with sessionStorage
          document.addEventListener('DOMContentLoaded', () => {
            const linksContainer = document.getElementById('links');
            if (!linksContainer) return;

            // Get the first link specifically
            const firstLink = linksContainer.querySelector('a');

            const visitedKey = 'visitedLinks';
            let visitedLinks = JSON.parse(sessionStorage.getItem(visitedKey) || '[]');

            // Mark the first link as visited if it exists and isn't already marked
            if (firstLink && !visitedLinks.includes(firstLink.getAttribute('href'))) {
              visitedLinks.push(firstLink.getAttribute('href'));
              sessionStorage.setItem(visitedKey, JSON.stringify(visitedLinks));
            }

            // Apply style to all visited links on load (including the first one)
            linksContainer.querySelectorAll('a').forEach(link => {
              if (visitedLinks.includes(link.getAttribute('href'))) {
                link.classList.add('session-visited');
              }
            });

            // Add click listener to track new visits
            linksContainer.addEventListener('click', (event) => {
              if (event.target.tagName === 'A' && event.target.hasAttribute('href')) {
                const href = event.target.getAttribute('href');
                if (!visitedLinks.includes(href)) {
                  visitedLinks.push(href);
                  sessionStorage.setItem(visitedKey, JSON.stringify(visitedLinks));
                  event.target.classList.add('session-visited'); // Add style immediately
                }
              }
            });
          });
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
          body {
            margin: 0 !important;
            font-family: "Nunito Sans", sans-serif;
            color: #303030 !important;
            background-color: #e0e0e0;
          }
          .main-content {
            padding: 1rem 1.5rem 2rem !important;
          }
          .pagy-bootstrap .pagination {
            margin: 0;
          }
          .pagy, .pagy-bootstrap, .pagy-bulma {
            background-color: white;
            padding: .5em;
            margin: .3em 0;
            width: fit-content;
            box-shadow: 8px 8px 18px 0px rgba(0,0,0,0.25);
          }
        </style>
        <style>
          #help summary {
            font-weight: bold;
          }
          #help dl {
            margin: 0;
          }
          #help dt {
            font-weight: bold;
            margin: .4rem 0 .1rem 0;
          }
          #help ul {
            margin: 0;
            padding: 0 0 0 2rem;
          }
          #help dd {
            margin-bottom: .25rem;
            margin-left: 1rem;
          }
          #help code {
            display: inline-block;
            line-height: .8rem;
            border-radius: .625rem;
            background-color: white;
            padding: .0625rem .3125rem;
          }
          h1 {
            font-size: 2rem;
            font-weight: bold;
          } 
          h4 {
            font-size: 1rem;
            font-weight: bold;
            margin-bottom: 1rem;
          }
          div.mask {
            margin-top: 2rem;
          }
          .mask .pagy, .mask .pagy-bootstrap, .mask .pagy-bulma {
            background-color: black !important;
          }
          .mask .pagy *:not([role="separator"]) {
            background-color: white !important;
          }
          .mask .pagy a:not(.gap):not([href]) { /* disabled and current */
            opacity: 1 !important;
          }
          .mask .pagy * {
            border-color: white !important;
          }
          .mask .pagy *,
          .mask .pagy-bootstrap *,
          .mask .pagy-bulma a,
          .mask .pagy-bulma label,
          .mask .pagy-bulma .pagination-ellipsis  {
            color: white !important;
          }
          .mask .pagy-bootstrap .page-item .page-link,
          .mask .pagy-bulma li.pagination-link,
          .mask .pagy-bulma input,
          .mask .pagy-bulma a, .mask .pagy-bulma a.pagination-previous, .mask .pagy-bulma a.pagination-next {
            border-color: white !important;
            background-color: white !important;
            opacity: 1;
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
          <details id="help">
            <summary>Help</summary>
            <dl>
            <dt>Preparation</dt>
              <dd>
                Install the <a href="https://chromewebstore.google.com/detail/fusebase-pro-capture-scre/fddbloohgcjopkmnjdeodjcfbgiimpcn">Chrome extension FusionBase Pro</a>
              </dd>
            <dt>Usage</dt>
              <ul>
                <li>As soon as you enter a docshot page, the name of the file to save is copied to your clipboard</li>
                <li>Use the "Capture Fragment" feature to capture the two `.pagy` nav/div in each page</li>
                <li>Save the first one in <code>assets/png/screenshots</code> <i>(just paste the name already in the clipboard)</i></li>
                <li>Save the second one in <code>assets/png/masks</code> <i>(just paste the name already in the clipboard)</i></li>
                <li>Go to the next (black) link and repeat <i>(the green links are the visited pages)</i></li>
              </ul>
            <dt>Finalize</dt>
              <dd>Run the zsh script at <code>assets/png/compose.zsh</code></dd>
            </dl>
          </details>
          <hr>
          <%= yield %>
        </div>
      </body>
      </html>
    HTML
  end

  template :main do
    <<~ERB
      <% case (meth ||= 'anchor_tags').to_sym %>
      <% when :anchor_tags %>
         <h4>pagy-anchor_tags.png</h4>
         <nav class="pagy" id="anchor-tags" aria-label="anchor-tags"><%= @pagy.previous_tag + ' ' + @pagy.next_tag %></nav>
         <div class="mask">
           <nav class="pagy" id="anchor-tags-mask" aria-label="anchor-tags-mask"><%= @pagy.previous_tag + ' ' + @pagy.next_tag %></nav>
         </div>
      <% when :limit_tag_js %>
        <h4>pagy-limit_tag_js.png</h4>
        <%= @pagy.limit_tag_js(id: 'limit-tag-js') %>
        <div class="mask">
           <%= @pagy.limit_tag_js(id: 'limit-tag-js') %>
        </div>

      <% when :series_nav %>
        <h4><%= style %>-series_nav.png</h4>
        <%= @pagy.series_nav(style, classes:,
                             id: 'series-nav',
                             aria_label: 'series-nav') %>
        <div class="mask">
          <%= @pagy.series_nav(style, classes:,
                               id: 'series-nav-mask',
                               aria_label: 'series-nav-mask') %>
        </div>
      <% when :series_nav_js %>
        <h4><%= style %>-series_nav_js-<%= slots %>.png</h4>
        <%= @pagy.series_nav_js(style, classes:,
                                id: 'series-nav-js',
                                aria_label: 'series-nav-js',
                                steps: { 0 => slots.to_i }) %>
        <div class="mask">
          <%= @pagy.series_nav_js(style, classes:,
                                  id: 'series-nav-js-mask',
                                  aria_label: 'series-nav-js-mask',
                                  steps: { 0 => slots.to_i }) %>
        </div>
      <% when :input_nav_js %>
        <h4><%= style %>-input_nav_js.png</h4>
        <%= @pagy.input_nav_js(style, classes:,
                               id: 'input-nav-js',
                               aria_label: 'input-nav-js') %>
        <div class="mask">
           <%= @pagy.input_nav_js(style, classes:,
                                  id: 'input-nav-js-mask',
                                  aria_label: 'input-nav-js-mask') %>
        </div>
      <% end %>
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
