# frozen_string_literal: true

# Self-contained, standalone Sinatra app usable to play with the pagy calendar extra

# This file uses mock collections from the repo, so you should run it in the cloned repo dir
# You can just clone the pagy repo and the just run it as indicated below.

# USAGE:
#    rackup -o 0.0.0.0 -p 8080 pagy_calendar_app.ru

# ADVANCED USAGE (with automatic app reload if you edit it):
#    gem install rerun
#    rerun -- rackup -o 0.0.0.0 -p 8080 pagy_calendar_app.ru

# Point your browser at http://0.0.0.0:8080

# Read the comments below to edit this app

require 'bundler/inline'

# Edit this gemfile declaration as you need
# and ensure to use gems updated to the latest versions
# NOTICE: if you get any installation error with the following setup
# temporarily remove the Gemfile and Gemfile.lock from the repo (they may interfere with the bundler/inline)

gemfile true do
  source 'https://rubygems.org'
  gem 'rack'
  # gem 'pagy'            # <--install from rubygems
  gem 'pagy', path: '../' # <-- use the local repo
  gem 'puma'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# Edit this section adding/removing the extras and Pagy::DEFAULT as needed
# pagy initializer
require 'pagy/extras/calendar'

Pagy::DEFAULT.freeze

# simple array-based collection that acts as standard DB collection
require_relative '../test/mock_helpers/calendar_collection'

require 'sinatra/base'
# Sinatra application
class PagyCalendarApp < Sinatra::Base
  enable :sessions

  configure do
    enable :inline_templates
  end
  include Pagy::Backend
  # Edit this section adding your own helpers as needed
  helpers do
    include Pagy::Frontend
  end

  # Override the super method in order to set the local_minmax array dynamically
  def pagy_calendar_get_vars(collection, vars)
    super
    vars[:local_minmax] ||= collection.minmax.map { |t| t.getlocal(0) }
    vars
  end

  # Implemented by the user: use pagy.utc_from, pagy.utc_to to get the page records from your collection
  def pagy_calendar_get_items(collection, pagy)
    collection.select_page_of_records(pagy.utc_from, pagy.utc_to)
  end

  # This will reset the nested page to start from 1 when the user changes the unit page (year, month, week or day)
  # You may need to differentiate the param and variable names if you need more nesting
  # (e.g. year_pagy/year_page, month_pagy/month_page and regular pagination)
  def handle_nesting_params
    return unless session[:unit_page] != params[:unit_page]

    params.delete(:page)  # reset the page param for the inner object
    session[:unit_page] = params[:unit_page]
  end

  # Edit this action as needed
  get '/' do
    handle_nesting_params
    collection = MockCalendarCollection.new
    @unit_pagy, unit_page = pagy_calendar(collection, page_param: :unit_page, unit: :year)
    @pagy, @records = pagy(unit_page, items: 10)
    erb :pagy_demo # template available in the __END__ section as @@ pagy_demo
  end
end

run PagyCalendarApp

__END__

@@ layout
<html>
<head>
</head>
<body>
  <%= yield %>
</body>
</html>

@@ pagy_demo
<h3>Pagy Calendar Application</h3>
<p> Self-contained, standalone Sinatra app usable to play with the pagy calendar extra</p>
<hr>
<h4>Pagy Nested Calendar</h4>
<br>
<%= pagy_nav(@unit_pagy) %>
<% @records.each do |record| %>
<p><%= record.to_s %></p>
<% end %>
<p><%= "#{pagy_info(@pagy)} for #{@unit_pagy.page_label}" %></p>
<%= pagy_nav(@pagy) %>
