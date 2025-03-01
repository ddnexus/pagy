# frozen_string_literal: true

# DESCRIPTION
#    Reproduce rails related issues
#
# DOC
#    https://ddnexus.github.io/pagy/playground/#2-rails-app
#
# BIN HELP
#    bundle exec pagy -h
#
# DEV USAGE
#    bundle exec pagy clone rails
#    bundle exec pagy ./rails.ru
#
# URL
#    http://0.0.0.0:8000

VERSION = '9.3.3'

if VERSION != Pagy::VERSION
  Warning.warn("\n>>> WARNING! '#{File.basename(__FILE__)}-#{VERSION}' running with 'pagy-#{Pagy::VERSION}'! <<< \n\n")
end

# Bundle
require 'bundler/inline'
gemfile(!Pagy::ROOT.join('pagy.gemspec').exist?) do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'puma'
  gem 'rails', '~> 8.0'
  gem 'sqlite3'
end

# require 'rails/all'     # too much stuff
require 'action_controller/railtie'
require 'active_record'

OUTPUT = Rails.env.showcase? ? IO::NULL : $stdout

# Rails config
class PagyRails < Rails::Application # :nodoc:
  config.root = __dir__
  config.session_store :cookie_store, key: 'cookie_store_key'
  Rails.application.credentials.secret_key_base = 'absolute_secret'

  config.logger = Logger.new(OUTPUT)
  Rails.logger  = config.logger

  routes.draw do
    root to: 'comments#index'
    get '/javascript/:file', to: 'pagy#javascript', file: /.*/
  end
end

# AR config
dir = Rails.env.development? ? '.' : Dir.pwd # app dir in dev or pwd otherwise
unless File.writable?(dir)
  warn "ERROR: directory #{dir.inspect} is not writable (the pagy-rails-app needs to create DB files)"
  exit 1
end

# Activerecord initializer
ActiveRecord::Base.logger = Logger.new(OUTPUT)
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "#{dir}/tmp/pagy-rails.sqlite3")
ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
    t.string :title
  end

  create_table :comments, force: true do |t|
    t.string :body
    t.integer :post_id
  end
end

# Models
class Post < ActiveRecord::Base # :nodoc:
  has_many :comments
end

# :nodoc:

class Comment < ActiveRecord::Base # :nodoc:
  belongs_to :post
end

# :nodoc:

# Unused model, useful to test overriding conflicts
module Calendar
end

# DB seed
1.upto(11) do |pi|
  Post.create(title: "Post #{pi + 1}")
end
Post.all.each_with_index do |post, pi|
  2.times { |ci| Comment.create(post:, body: "Comment #{ci + 1} to Post #{pi + 1}") }
end

# Controllers
class CommentsController < ActionController::Base # :nodoc:
  include Rails.application.routes.url_helpers
  include Pagy::Method

  def index
    @pagy, @comments = pagy(:offset, Comment.all, limit: 10, requestable_limit: 100)
    # Reload the page in the network tab of the Chrome Inspector to check
    # response.headers.merge!(@pagy.headers_hash)
    render inline: TEMPLATE
  end
end

# You don't need this in real rails apps (see https://ddnexus.github.io/pagy/docs/api/javascript/setup/#2-configure)
class PagyController < ActionController::Base
  def javascript
    format = params[:file].split('.').last
    if format == 'js'
      render js: Pagy::ROOT.join('javascript', params[:file]).read
    elsif format == 'map'
      render json: Pagy::ROOT.join('javascript', params[:file]).read
    end
  end
end

run PagyRails

TEMPLATE = <<~ERB
  <!DOCTYPE html>
  <html lang="en">
    <html>
    <head>
    <title>Pagy Rails App</title>
      <script src="/javascript/pagy.js"></script>
      <script>
        window.addEventListener("load", Pagy.init);
      </script>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style type="text/css">
        @media screen { html, body {
          font-size: 1rem;
          line-height: 1.2s;
          padding: 0;
          margin: 0;
        } }
        body {
          background: white !important;
          margin: 0 !important;
          font-family: sans-serif !important;
        }
        .content {
          padding: 1rem 1.5rem 2rem !important;
        }

        /* Quick demo for overriding the element style attribute of certain pagy helpers
        .pagy input[style] {
          width: 5rem !important;
        }
        */

        /*
          If you want to customize the style,
          please replace the line below with the actual file content
        */
        <%== Pagy::ROOT.join('stylesheet/pagy.css').read %>
      </style>
    </head>

    <body>

      <div class="content">
        <h1>Pagy Rails App</h1>
        <p> Self-contained, standalone Rails app usable to easily reproduce any rails related pagy issue.</p>
        <p>Please, report the following versions in any new issue.</p>
        <h2>Versions</h2>
        <ul>
          <li>Ruby:  <%== RUBY_VERSION %></li>
          <li>Rack:  <%== Rack::RELEASE %></li>
          <li>Rails: <%== Rails.version %></li>
          <li>Pagy:  <%== Pagy::VERSION %></li>
        </ul>

        <h3>Collection</h3>
        <div id="records" class="collection">
        <% @comments.each do |comment| %>
          <p style="margin: 0;"><%= comment.body %></p>
        <% end %>
        </div>
        <hr>

        <h4>pagy.nav_tag</h4>
        <%== @pagy.nav_tag(id: 'nav', aria_label: 'Pages nav') %>

        <h4>pagy.nav_js_tag</h4>
        <%== @pagy.nav_js_tag(id: 'nav-js', aria_label: 'Pages nav_js') %>

        <h4>pagy.combo_nav_js_tag</h4>
        <%== @pagy.combo_nav_js_tag(id: 'combo-nav-js', aria_label: 'Pages combo_nav_js') %>

        <h4>pagy.limit_selector_js_tag</h4>
        <%== @pagy.limit_selector_js_tag(id: 'limit-selector-js') %>

        <h4>pagy.info_tag</h4>
        <%== @pagy.info_tag(id: 'pagy-info') %>
      </div>

    </body>
  </html>
ERB
