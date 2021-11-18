# frozen_string_literal: true

# Self-contained, standalone Sinatra app usable to play with the pagy calendar extra

# This file uses mock collections from the repo, so you should run it from the cloned repo dir
# You can just clone the pagy repo and then run it as indicated below (from the pagy root dir).

# USAGE:
#    rackup -o 0.0.0.0 -p 8080 apps/pagy_calendar_app.ru

# ADVANCED USAGE (with automatic app reload if you edit it):
#    gem install rerun
#    rerun -- rackup -o 0.0.0.0 -p 8080 apps/pagy_calendar_app.ru

# Point your browser at http://0.0.0.0:8080

# Read the comments below to edit this app

require 'bundler/inline'

# Edit this gemfile declaration as you need and ensure to use gems updated to the latest versions
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

# Edit this section adding/removing the extras and DEFAULT as needed
# pagy initializer
require 'pagy/extras/calendar'
require 'pagy/extras/bootstrap'

Pagy::DEFAULT.freeze

# Simple array-based collection that acts as standard DB collection
require_relative '../test/mock_helpers/collection'

require 'sinatra/base'
# Sinatra application
class PagyCalendarApp < Sinatra::Base
  configure do
    enable :inline_templates
  end
  include Pagy::Backend

  # Edit this section adding your own helpers as needed
  helpers do
    include Pagy::Frontend
  end

  # This method must be implemented by the application.
  # It must return the starting and ending local Time objects array defining the calendar :period
  def pagy_calendar_period(collection)
    collection.minmax.map(&:getlocal)   # time converted in your local time
  end

  # This method must be implemented by the application.
  # It receives the main collection and must return a filtered version of it.
  # The filter logic must be equivalent to {storage_time >= from && storage_time < to}
  def pagy_calendar_filter(collection, from, to)
    collection.select_page_of_records(from.utc, to.utc)  # storage in UTC
  end

  # Controller action
  get '/' do
    collection = MockCollection::Calendar.new
    # The conf Hash defines the pagy objects variables keyed by calendar unit and the final pagy standard object
    # The :skip is an optional and arbitrarily named param that skips the calendar pagination and uses only the pagy
    # object to paginate the unfiltered collection. (It's active by default even without a :skip param).
    # You way want to invert the logic (also in the view) with something like `active: params[:active]`,
    # which would be inactive by default and only active on demand.
    @calendar, @pagy, @records = pagy_calendar(collection, year:   { size: [1, 1, 1, 1] },
                                                           month:  { size: [0, 12, 12, 0], format: '%b' },
                                                           pagy:   { items: 10 },
                                                           active: !params[:skip])
    erb :pagy_demo # template available in the __END__ section as @@ pagy_demo
  end
end

run PagyCalendarApp

__END__

@@ layout
<html style="font-size: 0.7rem">
<head>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body style="background-color: #f7f7f7; color: #51585F;">
  <%= yield %>
</body>
</html>

@@ pagy_demo
<div class="container">

  <h3>Pagy Calendar Application</h3>
  <p>Self-contained, standalone Sinatra app implementing nested calendar pagination for year and month units.</p>
  <p>See the <a href="https://ddnexus.github.io/pagy/extras/calendar">Pagy Calendar Extra</a> for details.</p>
  <hr>

  <!-- manual toggle calendar UI -->
  <p>
  <% if params[:skip] %>
    <a href="/" >Show Calendar</a>
  <% else %>
    <a href="?skip=true" >Hide Calendar</a>
  <% end %>
  </p>

  <!-- calendar navs -->
  <% if @calendar %>
    <%= pagy_bootstrap_nav(@calendar[:year]) %>   <!-- year nav -->
    <%= pagy_bootstrap_nav(@calendar[:month]) %>  <!-- month nav -->
  <% end %>

  <!-- page info extended for the calendar unit -->
  <div class="alert alert-primary" role="alert">
    <%= pagy_info(@pagy) %><%= " for <b>#{@calendar[:month].label(format: '%B %Y')}</b>" if @calendar %>
  </div>

  <!-- page records (time converted in your local time)-->
  <div class="list-group">
    <% @records.each do |record| %>
    <p class="list-group-item"><%= record.getlocal.to_s %></p>
    <% end %>
  </div>

  <!-- standard pagination of the selected month -->
  <p><%= pagy_bootstrap_nav(@pagy) if @pagy.pages > 1 %><p/>

</div>
