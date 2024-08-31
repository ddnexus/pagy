# frozen_string_literal: true

# Starting point to reproduce rails related pagy issues

# DEV USAGE
#    pagy clone rails
#    pagy ./rails.ru

# URL
#    http://0.0.0.0:8000

# HELP
#    pagy -h

# DOC
#    https://ddnexus.github.io/pagy/playground/#2-rails-app

VERSION = '9.0.8'

# Gemfile
require 'bundler/inline'
require 'bundler'
Bundler.configure
gemfile(ENV['PAGY_INSTALL_BUNDLE'] == 'true') do
  source 'https://rubygems.org'
  gem 'oj'
  gem 'puma'
  gem 'rails'
  # activerecord/sqlite3_adapter.rb probably useless) constraint !!!
  # https://github.com/rails/rails/blame/v7.1.3.4/activerecord/lib/active_record/connection_adapters/sqlite3_adapter.rb#L14
  gem 'sqlite3', '~> 1.4.0'
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
    get '/javascripts/:file', to: 'pagy#javascripts', file: /.*/
  end
end

# AR config
dir = Rails.env.development? ? '.' : Dir.pwd  # app dir in dev or pwd otherwise
unless File.writable?(dir)
  warn "ERROR: directory #{dir.inspect} is not writable (the pagy-rails-app needs to create DB files)"
  exit 1
end

# Pagy initializer
require 'pagy/extras/pagy'
require 'pagy/extras/limit'
require 'pagy/extras/overflow'
require 'pagy/extras/headers'
Pagy::DEFAULT[:limit]    = 10
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT.freeze

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
end # :nodoc:

class Comment < ActiveRecord::Base # :nodoc:
  belongs_to :post
end # :nodoc:

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

# Helpers
module CommentsHelper
  include Pagy::Frontend
end

# Controllers
class CommentsController < ActionController::Base # :nodoc:
  include Rails.application.routes.url_helpers
  include Pagy::Backend

  def index
    @pagy, @comments = pagy(Comment.all)
    pagy_headers_merge(@pagy)
    render inline: TEMPLATE
  end
end

# You don't need this in real rails apps (see https://ddnexus.github.io/pagy/docs/api/javascript/setup/#2-configure)
class PagyController < ActionController::Base
  def javascripts
    format = params[:file].split('.').last
    if format == 'js'
      render js: Pagy.root.join('javascripts', params[:file]).read
    elsif format == 'map'
      render json: Pagy.root.join('javascripts', params[:file]).read
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
      <script src="/javascripts/pagy.min.js"></script>
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
        <%== Pagy.root.join('stylesheets', 'pagy.css').read %>
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

        <h4>pagy_nav</h4>
        <%== pagy_nav(@pagy, id: 'nav', aria_label: 'Pages nav') %>

        <h4>pagy_nav_js</h4>
        <%== pagy_nav_js(@pagy, id: 'nav-js', aria_label: 'Pages nav_js') %>

        <h4>pagy_combo_nav_js</h4>
        <%== pagy_combo_nav_js(@pagy, id: 'combo-nav-js', aria_label: 'Pages combo_nav_js') %>

        <h4>pagy_limit_selector_js</h4>
        <%== pagy_limit_selector_js(@pagy, id: 'limit-selector-js') %>

        <h4>pagy_info</h4>
        <%== pagy_info(@pagy, id: 'pagy-info') %>
      </div>

    </body>
  </html>
ERB
