# frozen_string_literal: true

# DESCRIPTION
#    Showcase the Keynav pagination (ActiveRecord example)
#
# DOC
#    https://ddnexus.github.io/pagy/playground/#5-keyset-apps
#
# BIN HELP
#    bundle exec pagy -h
#
# DEV USAGE
#    bundle exec pagy clone keynav
#    bundle exec pagy ./keynav.ru
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
  gem 'activerecord'
  gem 'puma'
  gem 'sinatra'
  gem 'sqlite3'
end

# Sinatra setup
require 'sinatra/base'
# Sinatra application
class PagyKeynav < Sinatra::Base
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

  # Root route/action
  get '/' do
    Time.zone = 'UTC'

    @order       = { animal: :asc, name: :asc, birthdate: :desc, id: :asc }
    @pagy, @pets = pagy(:keynav_js, Pet.order(@order), limit: 4, requestable_limit: 100)
    @ids         = @pets.pluck(:id)
    erb :main
  end

  helpers do
    def order_symbol(dir)
      { asc: '&#x2197;', desc: '&#x2198;' }[dir]
    end
  end

  # Views
  template :layout do
    <<~ERB
      <!DOCTYPE html>
      <html lang="en">
      <html>
      <head>
         <title>Pagy Keynav App</title>
        <script src="javascript/pagy.js"></script>
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

          <%= Pagy::ROOT.join('stylesheet/pagy.css').read %>
        </style>
      </head>
      <body>
        <%= yield %>
      </body>
      </html>
    ERB
  end

  template :main do
    <<~ERB
      <div class="content">
        <h1>Pagy Keynav App</h1>
        <p>Self-contained, standalone app usable to easily reproduce any Keynav related pagy issue
        with ActiveRecord sets. Notice that Keynav works also with Sequel sets</p>
        <p>Please, report the following versions in any new issue.</p>
        <h2>Versions</h2>
        <ul>
          <li>Ruby:    <%= RUBY_VERSION %></li>
          <li>Rack:    <%= Rack::RELEASE %></li>
          <li>Sinatra: <%= Sinatra::VERSION %></li>
          <li>Pagy:    <%= Pagy::VERSION %></li>
        </ul>

        <h3>Collection</h3>
        <p id="records">@ids: <%= @ids.join(',') %></p>
        <div class="collection">
        <table border="1" style="border-collapse: collapse; border-spacing: 0; padding: 0.2rem;">
          <tr>
            <th scope="col">animal <%= order_symbol(@order[:animal]) %></th>
            <th scope="col">name <%= order_symbol(@order[:name]) %></th>
            <th scope="col">birthdate <%= order_symbol(@order[:birthdate]) %></th>
            <th scope="col">id <%= order_symbol(@order[:id]) %></th>
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
        <h3>pagy.nav_tag</h3>
        <p>
          <%= @pagy.nav_tag(id: 'nav', aria_label: 'Pages (nav)') %>
        </p>
          <h3>pagy.nav_js_tag (responsive)</h3>
        <p>
          <%= @pagy.nav_js_tag(id: 'nav-js-responsive',
                           aria_label: 'Pages (nav_js_responsive)',
                           steps: { 0 => 5, 500 => 7, 750 => 9, 1000 => 11 }) %>
        </p>
          <h3>pagy.combo_nav_js_tag</h3>
        <p>
          <%= @pagy.combo_nav_js_tag(id: 'combo-nav-js', aria_label: 'Pages (combo_nav_js)') %>
        </p>
      </div>
    ERB
  end
end

# ActiveRecord setup
require 'active_record'

# Match the microsecods with the strings stored into the time columns of SQLite
# ActiveSupport::JSON::Encoding.time_precision = 6

# Log
output                    = ENV['APP_ENV'].equal?('showcase') ? IO::NULL : $stdout
ActiveRecord::Base.logger = Logger.new(output)
# SQLite DB files
dir = ENV['APP_ENV'].equal?('development') ? '.' : Dir.pwd # app dir in dev or pwd otherwise
abort "ERROR: Cannot create DB files: the directory #{dir.inspect} is not writable." \
      unless File.writable?(dir)
# Connection
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "#{dir}/tmp/pagy-keyset-ar.sqlite3")
# Schema
ActiveRecord::Schema.define do
  create_table :pets, force: true do |t|
    t.string   :animal
    t.string   :name
    t.date     :birthdate
  end
end

# Models
class Pet < ActiveRecord::Base; end

data = <<~DATA
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
DATA

# DB seed
pets = []
data.each_line(chomp: true) do |pet|
  name, animal, birthdate = pet.split('|').map(&:strip)
  pets << { name:, animal:, birthdate: }
end
Pet.insert_all(pets)

run PagyKeynav
