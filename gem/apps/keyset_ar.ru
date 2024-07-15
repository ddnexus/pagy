# frozen_string_literal: true

# Starting point to reproduce keyset related pagy issues

# DEV USAGE
#    pagy clone rails
#    pagy ./keyset.ru

# URL
#    http://0.0.0.0:8000

# HELP
#    pagy -h

# DOC
#    https://ddnexus.github.io/pagy/playground/#5-keyset-app

VERSION = '8.6.2'

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
class PagyKeyset < Rails::Application # :nodoc:
  config.root = __dir__
  config.session_store :cookie_store, key: 'cookie_store_key'
  Rails.application.credentials.secret_key_base = 'absolute_secret'

  config.logger = Logger.new(OUTPUT)
  Rails.logger  = config.logger

  routes.draw do
    root to: 'pets#index'
  end
end

dir = Rails.env.development? ? '.' : Dir.pwd  # app dir in dev or pwd otherwise
unless File.writable?(dir)
  warn "ERROR: directory #{dir.inspect} is not writable (the pagy-rails-app needs to create DB files)"
  exit 1
end

# Pagy initializer
require 'pagy/extras/pagy'
require 'pagy/extras/items'
require 'pagy/extras/keyset'
Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT.freeze

PETS = <<~PETS
  Luna  | dog    | 2018-03-10
  Coco  | cat    | 2019-05-15
  Dodo  | dog    | 2020-06-25
  Wiki  | bird   | 2018-03-12
  Baby  | rabbit | 2020-01-13
  Neki  | horse  | 2021-07-20
  Tino  | donkey | 2019-06-18
  Plot  | cat    | 2022-09-21
  Riki  | cat    | 2018-09-14
  Susi  | horse  | 2018-10-26
  Coco  | pig    | 2020-08-29
  Momo  | bird   | 2023-08-25
  Lili  | cat    | 2021-07-22
  Beli  | pig    | 2020-07-26
  Rocky | bird   | 2022-08-19
  Vyvy  | dog    | 2018-05-16
  Susi  | horse  | 2024-01-25
  Ella  | cat    | 2020-02-20
  Rocky | dog    | 2019-09-19
  Juni  | rabbit | 2020-08-24
  Coco  | bird   | 2021-03-17
  Susi  | dog    | 2021-07-28
  Luna  | horse  | 2023-05-14
  Gigi  | pig    | 2022-05-19
  Coco  | cat    | 2020-02-20
  Nino  | donkey | 2019-06-17
  Luna  | cat    | 2022-02-09
  Popi  | dog    | 2020-09-26
  Lili  | pig    | 2022-06-18
  Mina  | horse  | 2021-04-21
  Susi  | rabbit | 2023-05-18
  Toni  | donkey | 2018-06-22
  Rocky | horse  | 2019-09-28
  Lili  | cat    | 2019-03-18
  Roby  | cat    | 2022-06-19
  Anto  | horse  | 2022-08-18
  Susi  | pig    | 2021-04-21
  Boly  | bird   | 2020-03-29
  Sky   | cat    | 2023-07-19
  Lili  | dog    | 2020-01-28
  Fami  | snake  | 2023-04-27
  Lopi  | pig    | 2019-06-19
  Rocky | snake  | 2022-03-13
  Denis | dog    | 2022-06-19
  Maca  | cat    | 2022-06-19
  Luna  | dog    | 2022-08-15
  Jeme  | horse  | 2019-08-08
  Sary  | bird   | 2023-04-29
  Rocky | bird   | 2023-05-14
  Coco  | dog    | 2023-05-27
PETS

# Activerecord initializer
ActiveRecord::Base.logger = Logger.new(OUTPUT)
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "#{dir}/tmp/pagy-keyset-ar.sqlite3")
ActiveRecord::Schema.define do
  create_table :pets, force: true do |t|
    t.string   :animal
    t.string   :name
    t.date     :birthdate
  end
end

# Models
class Pet < ActiveRecord::Base
end

# DB seed
pets = []
PETS.each_line(chomp: true) do |pet|
  name, animal, birthdate = pet.split('|').map(&:strip)
  pets << { name:, animal:, birthdate: }
end
Pet.insert_all(pets)

# Helpers
module PetsHelper
  include Pagy::Frontend

  def order_symbol(dir)
    { asc: '&#x2197;', desc: '&#x2198;' }[dir]
  end
end

# Controllers
class PetsController < ActionController::Base # :nodoc:
  include Rails.application.routes.url_helpers
  include Pagy::Backend

  def index
    Time.zone = 'UTC'

    @order = { animal: :asc, name: :asc, birthdate: :desc, id: :asc }
    @pagy, @pets = pagy_keyset(Pet.order(@order))
    render inline: TEMPLATE
  end
end

TEMPLATE = <<~ERB
  <!DOCTYPE html>
  <html lang="en">
    <html>
    <head>
    <title>Pagy Keyset App</title>
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

        <%== Pagy.root.join('stylesheets', 'pagy.css').read %>
      </style>
    </head>

    <body>

      <div class="content">
        <h1>Pagy Keyset App</h1>
        <p>Self-contained, standalone Rails app usable to easily reproduce any keyset related pagy issue with ActiveRecord sets.</p>
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
        <table border="1" cellspacing="0" cellpadding="3">
          <tr>
            <th>animal <%== order_symbol(@order[:animal]) %></th>
            <th>name <%== order_symbol(@order[:name]) %></th>
            <th>birthdate <%== order_symbol(@order[:birthdate]) %></th>
            <th>id <%== order_symbol(@order[:id]) %></th>
          </tr>
          <% @pets.each do |pet| %>
          <tr>
            <td><%= pet.animal %></td>
            <td><%= pet.name %></td>
            <td><%= pet.birthdate %></td>
            <td><%= pet.id %></td>
          </tr>
          <% end %>
        </table>
        </div>
        <p>
        <nav class="pagy" id="next" aria-label="Pagy next">
          <%== pagy_next_a(@pagy, text: 'Next page &gt;') %>
        </nav>
      </div>

    </body>
  </html>
ERB

run PagyKeyset
