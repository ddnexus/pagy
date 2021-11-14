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
require 'pagy/extras/bootstrap'

Pagy::DEFAULT[:month_format] = '%b'
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

  # Override the super method in order to set the local_minmax array dynamically
  def pagy_calendar_get_vars(collection, vars)
    super
    vars[:local_minmax] ||= collection.minmax.map { |t| t.getlocal(0) }  # 0 utc_offset means 00:00 local time
    vars
  end

  # Implemented by the user: use pagy.utc_from, pagy.utc_to to get the page records from your collection
  # Our collection time is stored in UTC, so we don't need to convert the time provided by utc_from/utc_to
  def pagy_calendar_get_items(collection, pagy)
    collection.select_page_of_records(pagy.utc_from, pagy.utc_to)
  end

  # Controller action
  # Notice that with ActiveRecord collections the extra pagy_calendar calls don't generate any extra DB query
  # They just refine the ActiveRecord::Relation that will get executed later in the view.
  get '/' do
    collection = MockCollection::Calendar.new
    @year_pagy, year_page = pagy_calendar(collection, page_param:  :year_page,
                                                      unit:        :year,
                                                      size:        [1, 1, 1, 1],
                                                      params:      lambda do |params|       # remove inner page params
                                                                     params.delete('month_page')
                                                                     params.delete('page')
                                                                     params
                                                                   end)
    @month_pagy, month_page = pagy_calendar(year_page, page_param: :month_page,
                                                       unit:       :month,
                                                       size:       [0, 12, 12, 0],
                                                       params:     lambda do |params|      # remove inner page params
                                                                     params.delete('page')
                                                                     params
                                                                   end)
    @pagy, @records = pagy(month_page, items: 10)
    erb :pagy_demo # template available in the __END__ section as @@ pagy_demo
  end
end

run PagyCalendarApp

__END__

@@ layout
<html style="font-size: 0.7rem">
<head>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
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

  <!-- calendar pagination -->
  <%= pagy_bootstrap_nav(@year_pagy) %>   <!-- year nav -->
  <%= pagy_bootstrap_nav(@month_pagy) %>  <!-- month nav -->

  <!-- page info -->
  <div class="alert alert-primary" role="alert">
    <%= "#{pagy_info(@pagy)} for <b>#{@month_pagy.label(format: '%B %Y')}</b>" %>
  </div>

  <!-- page records -->
  <div class="list-group">
    <% @records.each do |record| %>
    <p class="list-group-item"><%= record.to_s %></p>
    <% end %>
  </div>

  <!-- items pagination -->
  <p><%= pagy_bootstrap_nav(@pagy) if @pagy.pages > 1 %><p/>

</div>
