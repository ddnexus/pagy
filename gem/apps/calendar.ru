# frozen_string_literal: true

# Interactive showcase for the pagy calendar extra (https://ddnexus.github.io/pagy/docs/extras/calendar)

# DEMO USAGE
#    pagy calendar

# DEV USAGE
#    pagy clone calendar
#    pagy ./calendar.ru

# URL
#    http://0.0.0.0:8000

# HELP
#    pagy -h

# DOC
#    https://ddnexus.github.io/pagy/playground/#4-calendar-app

VERSION = '8.4.5'

require 'bundler/inline'
require 'bundler'
Bundler.configure
gemfile(ENV['PAGY_INSTALL_BUNDLE'] == 'true') do
  source 'https://rubygems.org'
  gem 'activesupport'
  gem 'oj'
  gem 'puma'
  gem 'sinatra'
  gem 'sinatra-contrib'
end

# pagy initializer
require 'pagy/extras/calendar'
require 'pagy/extras/bootstrap'
Pagy::DEFAULT.freeze

require 'sinatra/base'
# Sinatra application
class PagyCalendar < Sinatra::Base
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
    collection.minmax.map(&:in_time_zone)
  end

  # This method must be implemented by the application.
  # It receives the main collection and must return a filtered version of it.
  # The filter logic must be equivalent to {storage_time >= from && storage_time < to}
  def pagy_calendar_filter(collection, from, to)
    collection.select_page_of_records(from.utc, to.utc)  # storage in UTC
  end

  # Controller action
  get '/' do
    Time.zone  = 'EST'   # convert the UTC storage time to time with zone 'EST'
    yaml       = settings.templates[:yaml_collection].first
    array      = YAML.load(yaml, permitted_classes: [ActiveSupport::TimeWithZone, ActiveSupport::TimeZone, Time], aliases: ['1'])
    collection = CalendarCollection.new(array)
    # Default calendar
    # The conf Hash defines the pagy objects variables keyed by calendar unit and the final pagy standard object
    # The :skip is an optional and arbitrarily named param that skips the calendar pagination and uses only the pagy
    # object to paginate the unfiltered collection. (It's active by default even without a :skip param).
    # You way want to invert the logic (also in the view) with something like `active: params[:active]`,
    # which would be inactive by default and only active on demand.
    @calendar, @pagy, @records = pagy_calendar(collection, year:   {},
                                                           month:  {},
                                                           day:    {},
                                                           active: !params[:skip])
    Time.now.to_s
    erb :pagy_demo # template available in the __END__ section as @@ pagy_demo
  end
end

run PagyCalendar

# Simple array-based collection that acts as a standard DB collection.
class CalendarCollection < Array
  def initialize(...)
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

  # Select days from the beginning of start_day to the end of end_day
  # Accepts strings or DateTime args
  def select_page_of_records(start_date, end_date)
    paged = select { |date| date >= start_date && date < end_date }
    # mock AR scope, returning the same type of object
    self.class.new(paged)
  end
end

__END__

@@ layout
<!DOCTYPE html>
<html lang="en" style="font-size: 0.8rem">
<head>
  <title>Pagy Calendar App</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
        integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body style="background-color: #f7f7f7; color: #51585F;">
  <%= yield %>
</body>
</html>

@@ pagy_demo
<div class="container">

  <h1>Pagy Calendar App</h1>
  <p>Self-contained, standalone Sinatra app implementing nested calendar pagination for year, month, day units.</p>
  <p>See the <a href="https://ddnexus.github.io/pagy/docs/extras/calendar">Pagy Calendar Extra</a> for details.</p>
  <hr>

  <!-- calendar UI manual toggle -->
  <p>
  <% if params[:skip] %>
    <a id="toggle" href="/" >Show Calendar</a>
  <% else %>
    <a id="toggle" href="?skip=true" >Hide Calendar</a>
    <br>
    <a id="go-to-day" href="<%= pagy_calendar_url_at(@calendar, Time.zone.parse('2022-03-02')) %>">Go to the 2022-03-02 Page</a>
    <!-- You can use Time.zone.now to find the current page if your time period include today -->
    <% end %>
  </p>

  <!-- calendar filtering navs -->
  <% if @calendar %>
    <p>Showtime: <%= @calendar.showtime %></p>
    <%= pagy_bootstrap_nav(@calendar[:year], id: "year-nav", aria_label: "Years") %>   <!-- year nav -->
    <%= pagy_bootstrap_nav(@calendar[:month], id: "month-nav", aria_label: "Months") %>  <!-- month nav -->
    <%= pagy_bootstrap_nav(@calendar[:day], id: "day-nav", aria_label: "Days") %> <!-- day nav -->
  <% end %>

  <!-- page info extended for the calendar unit -->
  <div class="alert alert-primary" role="alert">
    <%= pagy_info(@pagy, id: 'pagy-info') %><%= " for <b>#{@calendar.showtime.strftime('%Y-%m-%d')}</b>" if @calendar %>
  </div>

  <!-- page records (time converted in your local time)-->
  <div id="records" class="list-group">
    <% @records.each do |record| %>
    <p class="list-group-item"><%= record.in_time_zone.to_s %></p>
    <% end %>
  </div>

  <!-- standard pagination of the selected month -->
  <p><%= pagy_bootstrap_nav(@pagy, id: 'pages-nav', aria_label: 'Pages') if @pagy.pages > 1 %><p/>

</div>

@@ yaml_collection
---
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-10-21 13:18:23.000000000 Z
  zone: &1 !ruby/object:ActiveSupport::TimeZone
    name: GMT
  time: 2021-10-21 13:18:23.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-10-21 23:14:50.000000000 Z
  zone: *1
  time: 2021-10-21 23:14:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-10-23 01:06:02.000000000 Z
  zone: *1
  time: 2021-10-23 01:06:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-10-25 18:54:35.000000000 Z
  zone: *1
  time: 2021-10-25 18:54:35.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-10-26 02:22:17.000000000 Z
  zone: *1
  time: 2021-10-26 02:22:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-10-28 22:59:49.000000000 Z
  zone: *1
  time: 2021-10-28 22:59:49.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-10-30 15:02:25.000000000 Z
  zone: *1
  time: 2021-10-30 15:02:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-02 04:03:39.000000000 Z
  zone: *1
  time: 2021-11-02 04:03:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-04 22:41:23.000000000 Z
  zone: *1
  time: 2021-11-04 22:41:23.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-06 00:34:29.000000000 Z
  zone: *1
  time: 2021-11-06 00:34:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-06 23:56:16.000000000 Z
  zone: *1
  time: 2021-11-06 23:56:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-07 06:22:04.000000000 Z
  zone: *1
  time: 2021-11-07 06:22:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-07 19:46:08.000000000 Z
  zone: *1
  time: 2021-11-07 19:46:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-08 09:31:13.000000000 Z
  zone: *1
  time: 2021-11-08 09:31:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-09 17:22:03.000000000 Z
  zone: *1
  time: 2021-11-09 17:22:03.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-11 05:29:54.000000000 Z
  zone: *1
  time: 2021-11-11 05:29:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-13 09:41:04.000000000 Z
  zone: *1
  time: 2021-11-13 09:41:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-16 07:48:22.000000000 Z
  zone: *1
  time: 2021-11-16 07:48:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-16 12:43:44.000000000 Z
  zone: *1
  time: 2021-11-16 12:43:44.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-17 16:03:07.000000000 Z
  zone: *1
  time: 2021-11-17 16:03:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-20 02:39:01.000000000 Z
  zone: *1
  time: 2021-11-20 02:39:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-21 02:01:24.000000000 Z
  zone: *1
  time: 2021-11-21 02:01:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-23 19:24:43.000000000 Z
  zone: *1
  time: 2021-11-23 19:24:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-26 11:47:22.000000000 Z
  zone: *1
  time: 2021-11-26 11:47:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-11-28 06:30:04.000000000 Z
  zone: *1
  time: 2021-11-28 06:30:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-01 00:13:55.000000000 Z
  zone: *1
  time: 2021-12-01 00:13:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-03 19:10:16.000000000 Z
  zone: *1
  time: 2021-12-03 19:10:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-04 00:43:47.000000000 Z
  zone: *1
  time: 2021-12-04 00:43:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-06 20:15:35.000000000 Z
  zone: *1
  time: 2021-12-06 20:15:35.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-09 16:27:07.000000000 Z
  zone: *1
  time: 2021-12-09 16:27:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-10 15:28:48.000000000 Z
  zone: *1
  time: 2021-12-10 15:28:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-10 23:08:16.000000000 Z
  zone: *1
  time: 2021-12-10 23:08:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-11 23:09:08.000000000 Z
  zone: *1
  time: 2021-12-11 23:09:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-14 04:56:58.000000000 Z
  zone: *1
  time: 2021-12-14 04:56:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-14 14:00:56.000000000 Z
  zone: *1
  time: 2021-12-14 14:00:56.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-15 22:58:51.000000000 Z
  zone: *1
  time: 2021-12-15 22:58:51.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-16 01:28:21.000000000 Z
  zone: *1
  time: 2021-12-16 01:28:21.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-16 20:16:54.000000000 Z
  zone: *1
  time: 2021-12-16 20:16:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-19 00:34:04.000000000 Z
  zone: *1
  time: 2021-12-19 00:34:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-19 06:58:41.000000000 Z
  zone: *1
  time: 2021-12-19 06:58:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-21 11:13:53.000000000 Z
  zone: *1
  time: 2021-12-21 11:13:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-23 07:28:50.000000000 Z
  zone: *1
  time: 2021-12-23 07:28:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-23 07:57:58.000000000 Z
  zone: *1
  time: 2021-12-23 07:57:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-23 18:32:13.000000000 Z
  zone: *1
  time: 2021-12-23 18:32:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-24 01:17:51.000000000 Z
  zone: *1
  time: 2021-12-24 01:17:51.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-25 05:36:16.000000000 Z
  zone: *1
  time: 2021-12-25 05:36:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-25 23:21:57.000000000 Z
  zone: *1
  time: 2021-12-25 23:21:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-27 12:18:57.000000000 Z
  zone: *1
  time: 2021-12-27 12:18:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-28 16:59:57.000000000 Z
  zone: *1
  time: 2021-12-28 16:59:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2021-12-31 15:10:23.000000000 Z
  zone: *1
  time: 2021-12-31 15:10:23.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-01 19:18:06.000000000 Z
  zone: *1
  time: 2022-01-01 19:18:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-03 08:36:27.000000000 Z
  zone: *1
  time: 2022-01-03 08:36:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-03 23:31:01.000000000 Z
  zone: *1
  time: 2022-01-03 23:31:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-05 02:14:57.000000000 Z
  zone: *1
  time: 2022-01-05 02:14:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-06 09:26:03.000000000 Z
  zone: *1
  time: 2022-01-06 09:26:03.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-07 20:22:22.000000000 Z
  zone: *1
  time: 2022-01-07 20:22:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-10 04:04:28.000000000 Z
  zone: *1
  time: 2022-01-10 04:04:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-11 17:17:55.000000000 Z
  zone: *1
  time: 2022-01-11 17:17:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-14 05:21:54.000000000 Z
  zone: *1
  time: 2022-01-14 05:21:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-16 01:18:58.000000000 Z
  zone: *1
  time: 2022-01-16 01:18:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-18 08:42:56.000000000 Z
  zone: *1
  time: 2022-01-18 08:42:56.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-19 00:45:04.000000000 Z
  zone: *1
  time: 2022-01-19 00:45:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-20 08:18:54.000000000 Z
  zone: *1
  time: 2022-01-20 08:18:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-22 05:26:38.000000000 Z
  zone: *1
  time: 2022-01-22 05:26:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-24 10:57:50.000000000 Z
  zone: *1
  time: 2022-01-24 10:57:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-26 09:47:02.000000000 Z
  zone: *1
  time: 2022-01-26 09:47:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-28 20:44:30.000000000 Z
  zone: *1
  time: 2022-01-28 20:44:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-01-31 16:19:50.000000000 Z
  zone: *1
  time: 2022-01-31 16:19:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-01 21:23:58.000000000 Z
  zone: *1
  time: 2022-02-01 21:23:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-04 14:41:57.000000000 Z
  zone: *1
  time: 2022-02-04 14:41:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-06 20:40:06.000000000 Z
  zone: *1
  time: 2022-02-06 20:40:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-07 23:03:50.000000000 Z
  zone: *1
  time: 2022-02-07 23:03:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-09 05:28:08.000000000 Z
  zone: *1
  time: 2022-02-09 05:28:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-10 02:19:12.000000000 Z
  zone: *1
  time: 2022-02-10 02:19:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-11 07:51:30.000000000 Z
  zone: *1
  time: 2022-02-11 07:51:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-12 13:46:16.000000000 Z
  zone: *1
  time: 2022-02-12 13:46:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-13 21:06:40.000000000 Z
  zone: *1
  time: 2022-02-13 21:06:40.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-15 11:37:50.000000000 Z
  zone: *1
  time: 2022-02-15 11:37:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-18 11:23:15.000000000 Z
  zone: *1
  time: 2022-02-18 11:23:15.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-20 08:01:49.000000000 Z
  zone: *1
  time: 2022-02-20 08:01:49.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-23 03:00:30.000000000 Z
  zone: *1
  time: 2022-02-23 03:00:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-24 21:52:25.000000000 Z
  zone: *1
  time: 2022-02-24 21:52:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-25 12:07:56.000000000 Z
  zone: *1
  time: 2022-02-25 12:07:56.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-27 04:20:20.000000000 Z
  zone: *1
  time: 2022-02-27 04:20:20.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-02-28 21:09:42.000000000 Z
  zone: *1
  time: 2022-02-28 21:09:42.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-02 23:35:41.000000000 Z
  zone: *1
  time: 2022-03-02 23:35:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-04 00:42:10.000000000 Z
  zone: *1
  time: 2022-03-04 00:42:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-05 00:59:10.000000000 Z
  zone: *1
  time: 2022-03-05 00:59:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-06 19:58:01.000000000 Z
  zone: *1
  time: 2022-03-06 19:58:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-07 07:48:09.000000000 Z
  zone: *1
  time: 2022-03-07 07:48:09.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-09 06:08:00.000000000 Z
  zone: *1
  time: 2022-03-09 06:08:00.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-10 05:45:08.000000000 Z
  zone: *1
  time: 2022-03-10 05:45:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-12 21:16:31.000000000 Z
  zone: *1
  time: 2022-03-12 21:16:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-15 08:17:44.000000000 Z
  zone: *1
  time: 2022-03-15 08:17:44.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-16 03:37:03.000000000 Z
  zone: *1
  time: 2022-03-16 03:37:03.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-18 05:07:54.000000000 Z
  zone: *1
  time: 2022-03-18 05:07:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-20 04:05:26.000000000 Z
  zone: *1
  time: 2022-03-20 04:05:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-22 10:52:33.000000000 Z
  zone: *1
  time: 2022-03-22 10:52:33.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-23 15:26:54.000000000 Z
  zone: *1
  time: 2022-03-23 15:26:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-24 09:01:04.000000000 Z
  zone: *1
  time: 2022-03-24 09:01:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-24 23:53:07.000000000 Z
  zone: *1
  time: 2022-03-24 23:53:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-27 13:45:17.000000000 Z
  zone: *1
  time: 2022-03-27 13:45:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-28 19:57:00.000000000 Z
  zone: *1
  time: 2022-03-28 19:57:00.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-29 15:42:35.000000000 Z
  zone: *1
  time: 2022-03-29 15:42:35.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-03-29 18:20:32.000000000 Z
  zone: *1
  time: 2022-03-29 18:20:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-01 15:35:47.000000000 Z
  zone: *1
  time: 2022-04-01 15:35:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-02 06:33:31.000000000 Z
  zone: *1
  time: 2022-04-02 06:33:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-03 18:27:19.000000000 Z
  zone: *1
  time: 2022-04-03 18:27:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-03 23:44:08.000000000 Z
  zone: *1
  time: 2022-04-03 23:44:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-06 10:59:32.000000000 Z
  zone: *1
  time: 2022-04-06 10:59:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-07 01:33:53.000000000 Z
  zone: *1
  time: 2022-04-07 01:33:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-08 10:26:34.000000000 Z
  zone: *1
  time: 2022-04-08 10:26:34.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-10 19:21:08.000000000 Z
  zone: *1
  time: 2022-04-10 19:21:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-12 01:50:04.000000000 Z
  zone: *1
  time: 2022-04-12 01:50:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-14 19:56:29.000000000 Z
  zone: *1
  time: 2022-04-14 19:56:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-15 09:08:22.000000000 Z
  zone: *1
  time: 2022-04-15 09:08:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-16 07:58:47.000000000 Z
  zone: *1
  time: 2022-04-16 07:58:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-17 16:31:40.000000000 Z
  zone: *1
  time: 2022-04-17 16:31:40.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-20 09:50:22.000000000 Z
  zone: *1
  time: 2022-04-20 09:50:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-23 04:24:22.000000000 Z
  zone: *1
  time: 2022-04-23 04:24:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-25 07:18:04.000000000 Z
  zone: *1
  time: 2022-04-25 07:18:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-27 16:57:48.000000000 Z
  zone: *1
  time: 2022-04-27 16:57:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-29 18:48:09.000000000 Z
  zone: *1
  time: 2022-04-29 18:48:09.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-04-29 20:30:25.000000000 Z
  zone: *1
  time: 2022-04-29 20:30:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-02 03:44:25.000000000 Z
  zone: *1
  time: 2022-05-02 03:44:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-03 15:27:57.000000000 Z
  zone: *1
  time: 2022-05-03 15:27:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-04 08:11:15.000000000 Z
  zone: *1
  time: 2022-05-04 08:11:15.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-07 00:42:14.000000000 Z
  zone: *1
  time: 2022-05-07 00:42:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-09 15:23:31.000000000 Z
  zone: *1
  time: 2022-05-09 15:23:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-10 19:11:49.000000000 Z
  zone: *1
  time: 2022-05-10 19:11:49.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-11 14:04:17.000000000 Z
  zone: *1
  time: 2022-05-11 14:04:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-14 12:09:34.000000000 Z
  zone: *1
  time: 2022-05-14 12:09:34.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-15 13:31:54.000000000 Z
  zone: *1
  time: 2022-05-15 13:31:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-17 21:21:37.000000000 Z
  zone: *1
  time: 2022-05-17 21:21:37.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-19 01:27:43.000000000 Z
  zone: *1
  time: 2022-05-19 01:27:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-21 04:34:59.000000000 Z
  zone: *1
  time: 2022-05-21 04:34:59.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-23 11:05:18.000000000 Z
  zone: *1
  time: 2022-05-23 11:05:18.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-23 19:14:50.000000000 Z
  zone: *1
  time: 2022-05-23 19:14:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-26 13:16:18.000000000 Z
  zone: *1
  time: 2022-05-26 13:16:18.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-27 11:39:35.000000000 Z
  zone: *1
  time: 2022-05-27 11:39:35.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-29 07:09:07.000000000 Z
  zone: *1
  time: 2022-05-29 07:09:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-05-30 15:13:23.000000000 Z
  zone: *1
  time: 2022-05-30 15:13:23.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-01 04:18:40.000000000 Z
  zone: *1
  time: 2022-06-01 04:18:40.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-01 11:11:51.000000000 Z
  zone: *1
  time: 2022-06-01 11:11:51.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-01 12:45:06.000000000 Z
  zone: *1
  time: 2022-06-01 12:45:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-03 07:08:31.000000000 Z
  zone: *1
  time: 2022-06-03 07:08:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-04 23:28:11.000000000 Z
  zone: *1
  time: 2022-06-04 23:28:11.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-07 12:14:01.000000000 Z
  zone: *1
  time: 2022-06-07 12:14:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-08 13:32:22.000000000 Z
  zone: *1
  time: 2022-06-08 13:32:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-10 18:56:37.000000000 Z
  zone: *1
  time: 2022-06-10 18:56:37.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-12 16:00:09.000000000 Z
  zone: *1
  time: 2022-06-12 16:00:09.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-15 13:28:55.000000000 Z
  zone: *1
  time: 2022-06-15 13:28:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-16 18:42:37.000000000 Z
  zone: *1
  time: 2022-06-16 18:42:37.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-17 00:36:21.000000000 Z
  zone: *1
  time: 2022-06-17 00:36:21.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-18 16:21:27.000000000 Z
  zone: *1
  time: 2022-06-18 16:21:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-20 13:50:27.000000000 Z
  zone: *1
  time: 2022-06-20 13:50:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-22 09:43:55.000000000 Z
  zone: *1
  time: 2022-06-22 09:43:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-25 09:43:17.000000000 Z
  zone: *1
  time: 2022-06-25 09:43:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-27 06:51:01.000000000 Z
  zone: *1
  time: 2022-06-27 06:51:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-28 09:10:53.000000000 Z
  zone: *1
  time: 2022-06-28 09:10:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-06-30 18:46:16.000000000 Z
  zone: *1
  time: 2022-06-30 18:46:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-01 16:05:14.000000000 Z
  zone: *1
  time: 2022-07-01 16:05:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-02 14:02:12.000000000 Z
  zone: *1
  time: 2022-07-02 14:02:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-05 11:08:11.000000000 Z
  zone: *1
  time: 2022-07-05 11:08:11.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-05 12:44:38.000000000 Z
  zone: *1
  time: 2022-07-05 12:44:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-08 03:55:17.000000000 Z
  zone: *1
  time: 2022-07-08 03:55:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-08 18:02:14.000000000 Z
  zone: *1
  time: 2022-07-08 18:02:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-09 09:41:17.000000000 Z
  zone: *1
  time: 2022-07-09 09:41:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-11 07:34:51.000000000 Z
  zone: *1
  time: 2022-07-11 07:34:51.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-13 05:11:19.000000000 Z
  zone: *1
  time: 2022-07-13 05:11:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-15 02:46:56.000000000 Z
  zone: *1
  time: 2022-07-15 02:46:56.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-16 15:40:39.000000000 Z
  zone: *1
  time: 2022-07-16 15:40:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-17 19:44:15.000000000 Z
  zone: *1
  time: 2022-07-17 19:44:15.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-19 00:31:12.000000000 Z
  zone: *1
  time: 2022-07-19 00:31:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-21 21:58:24.000000000 Z
  zone: *1
  time: 2022-07-21 21:58:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-22 05:25:48.000000000 Z
  zone: *1
  time: 2022-07-22 05:25:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-22 18:33:04.000000000 Z
  zone: *1
  time: 2022-07-22 18:33:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-24 07:42:24.000000000 Z
  zone: *1
  time: 2022-07-24 07:42:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-25 07:21:20.000000000 Z
  zone: *1
  time: 2022-07-25 07:21:20.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-27 12:02:44.000000000 Z
  zone: *1
  time: 2022-07-27 12:02:44.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-29 03:29:28.000000000 Z
  zone: *1
  time: 2022-07-29 03:29:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-29 11:35:43.000000000 Z
  zone: *1
  time: 2022-07-29 11:35:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-30 05:25:21.000000000 Z
  zone: *1
  time: 2022-07-30 05:25:21.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-30 19:39:10.000000000 Z
  zone: *1
  time: 2022-07-30 19:39:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-07-31 18:54:58.000000000 Z
  zone: *1
  time: 2022-07-31 18:54:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-03 11:18:44.000000000 Z
  zone: *1
  time: 2022-08-03 11:18:44.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-05 00:37:47.000000000 Z
  zone: *1
  time: 2022-08-05 00:37:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-05 12:08:08.000000000 Z
  zone: *1
  time: 2022-08-05 12:08:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-07 14:39:19.000000000 Z
  zone: *1
  time: 2022-08-07 14:39:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-08 09:52:59.000000000 Z
  zone: *1
  time: 2022-08-08 09:52:59.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-09 13:48:29.000000000 Z
  zone: *1
  time: 2022-08-09 13:48:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-11 19:03:04.000000000 Z
  zone: *1
  time: 2022-08-11 19:03:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-13 01:56:49.000000000 Z
  zone: *1
  time: 2022-08-13 01:56:49.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-15 11:33:09.000000000 Z
  zone: *1
  time: 2022-08-15 11:33:09.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-17 23:37:45.000000000 Z
  zone: *1
  time: 2022-08-17 23:37:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-19 00:47:19.000000000 Z
  zone: *1
  time: 2022-08-19 00:47:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-19 01:01:12.000000000 Z
  zone: *1
  time: 2022-08-19 01:01:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-21 07:37:55.000000000 Z
  zone: *1
  time: 2022-08-21 07:37:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-21 21:42:15.000000000 Z
  zone: *1
  time: 2022-08-21 21:42:15.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-23 10:55:39.000000000 Z
  zone: *1
  time: 2022-08-23 10:55:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-25 16:20:29.000000000 Z
  zone: *1
  time: 2022-08-25 16:20:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-27 06:28:14.000000000 Z
  zone: *1
  time: 2022-08-27 06:28:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-27 13:12:57.000000000 Z
  zone: *1
  time: 2022-08-27 13:12:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-28 23:00:13.000000000 Z
  zone: *1
  time: 2022-08-28 23:00:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-08-31 05:19:56.000000000 Z
  zone: *1
  time: 2022-08-31 05:19:56.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-02 18:00:18.000000000 Z
  zone: *1
  time: 2022-09-02 18:00:18.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-04 12:02:47.000000000 Z
  zone: *1
  time: 2022-09-04 12:02:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-06 00:57:21.000000000 Z
  zone: *1
  time: 2022-09-06 00:57:21.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-08 04:26:01.000000000 Z
  zone: *1
  time: 2022-09-08 04:26:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-09 04:55:45.000000000 Z
  zone: *1
  time: 2022-09-09 04:55:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-11 22:59:36.000000000 Z
  zone: *1
  time: 2022-09-11 22:59:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-12 00:54:25.000000000 Z
  zone: *1
  time: 2022-09-12 00:54:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-12 17:44:24.000000000 Z
  zone: *1
  time: 2022-09-12 17:44:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-12 20:47:30.000000000 Z
  zone: *1
  time: 2022-09-12 20:47:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-15 11:39:20.000000000 Z
  zone: *1
  time: 2022-09-15 11:39:20.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-16 07:54:15.000000000 Z
  zone: *1
  time: 2022-09-16 07:54:15.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-17 08:06:29.000000000 Z
  zone: *1
  time: 2022-09-17 08:06:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-18 07:17:17.000000000 Z
  zone: *1
  time: 2022-09-18 07:17:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-19 08:39:55.000000000 Z
  zone: *1
  time: 2022-09-19 08:39:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-22 06:32:56.000000000 Z
  zone: *1
  time: 2022-09-22 06:32:56.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-22 21:26:29.000000000 Z
  zone: *1
  time: 2022-09-22 21:26:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-24 16:06:50.000000000 Z
  zone: *1
  time: 2022-09-24 16:06:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-27 05:50:18.000000000 Z
  zone: *1
  time: 2022-09-27 05:50:18.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-28 12:12:13.000000000 Z
  zone: *1
  time: 2022-09-28 12:12:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-29 21:13:01.000000000 Z
  zone: *1
  time: 2022-09-29 21:13:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-09-30 00:09:29.000000000 Z
  zone: *1
  time: 2022-09-30 00:09:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-02 04:35:07.000000000 Z
  zone: *1
  time: 2022-10-02 04:35:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-02 16:30:20.000000000 Z
  zone: *1
  time: 2022-10-02 16:30:20.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-04 10:35:59.000000000 Z
  zone: *1
  time: 2022-10-04 10:35:59.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-04 23:39:37.000000000 Z
  zone: *1
  time: 2022-10-04 23:39:37.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-07 23:25:10.000000000 Z
  zone: *1
  time: 2022-10-07 23:25:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-08 20:31:14.000000000 Z
  zone: *1
  time: 2022-10-08 20:31:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-09 07:30:41.000000000 Z
  zone: *1
  time: 2022-10-09 07:30:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-11 07:29:41.000000000 Z
  zone: *1
  time: 2022-10-11 07:29:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-11 08:00:58.000000000 Z
  zone: *1
  time: 2022-10-11 08:00:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-14 03:22:26.000000000 Z
  zone: *1
  time: 2022-10-14 03:22:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-16 14:47:54.000000000 Z
  zone: *1
  time: 2022-10-16 14:47:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-17 00:28:32.000000000 Z
  zone: *1
  time: 2022-10-17 00:28:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-19 10:46:33.000000000 Z
  zone: *1
  time: 2022-10-19 10:46:33.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-21 02:39:31.000000000 Z
  zone: *1
  time: 2022-10-21 02:39:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-21 19:24:24.000000000 Z
  zone: *1
  time: 2022-10-21 19:24:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-23 05:38:26.000000000 Z
  zone: *1
  time: 2022-10-23 05:38:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-25 13:28:28.000000000 Z
  zone: *1
  time: 2022-10-25 13:28:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-26 20:26:31.000000000 Z
  zone: *1
  time: 2022-10-26 20:26:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-29 12:43:40.000000000 Z
  zone: *1
  time: 2022-10-29 12:43:40.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-10-31 11:21:43.000000000 Z
  zone: *1
  time: 2022-10-31 11:21:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-03 04:42:32.000000000 Z
  zone: *1
  time: 2022-11-03 04:42:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-04 20:26:28.000000000 Z
  zone: *1
  time: 2022-11-04 20:26:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-05 15:08:01.000000000 Z
  zone: *1
  time: 2022-11-05 15:08:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-06 10:55:38.000000000 Z
  zone: *1
  time: 2022-11-06 10:55:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-07 04:13:28.000000000 Z
  zone: *1
  time: 2022-11-07 04:13:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-08 03:42:59.000000000 Z
  zone: *1
  time: 2022-11-08 03:42:59.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-10 13:56:10.000000000 Z
  zone: *1
  time: 2022-11-10 13:56:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-13 13:01:38.000000000 Z
  zone: *1
  time: 2022-11-13 13:01:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-15 02:04:32.000000000 Z
  zone: *1
  time: 2022-11-15 02:04:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-17 09:10:48.000000000 Z
  zone: *1
  time: 2022-11-17 09:10:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-19 11:37:01.000000000 Z
  zone: *1
  time: 2022-11-19 11:37:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-20 06:15:33.000000000 Z
  zone: *1
  time: 2022-11-20 06:15:33.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-22 08:35:41.000000000 Z
  zone: *1
  time: 2022-11-22 08:35:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-24 20:42:50.000000000 Z
  zone: *1
  time: 2022-11-24 20:42:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-25 17:45:48.000000000 Z
  zone: *1
  time: 2022-11-25 17:45:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-28 06:16:15.000000000 Z
  zone: *1
  time: 2022-11-28 06:16:15.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-28 18:12:24.000000000 Z
  zone: *1
  time: 2022-11-28 18:12:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-11-30 20:09:46.000000000 Z
  zone: *1
  time: 2022-11-30 20:09:46.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-01 03:29:43.000000000 Z
  zone: *1
  time: 2022-12-01 03:29:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-02 03:58:02.000000000 Z
  zone: *1
  time: 2022-12-02 03:58:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-02 19:47:06.000000000 Z
  zone: *1
  time: 2022-12-02 19:47:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-04 14:54:02.000000000 Z
  zone: *1
  time: 2022-12-04 14:54:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-06 02:22:58.000000000 Z
  zone: *1
  time: 2022-12-06 02:22:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-06 09:29:06.000000000 Z
  zone: *1
  time: 2022-12-06 09:29:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-06 17:16:19.000000000 Z
  zone: *1
  time: 2022-12-06 17:16:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-09 14:10:12.000000000 Z
  zone: *1
  time: 2022-12-09 14:10:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-11 19:54:41.000000000 Z
  zone: *1
  time: 2022-12-11 19:54:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-11 23:48:45.000000000 Z
  zone: *1
  time: 2022-12-11 23:48:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-12 12:05:28.000000000 Z
  zone: *1
  time: 2022-12-12 12:05:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-12 21:37:48.000000000 Z
  zone: *1
  time: 2022-12-12 21:37:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-15 05:08:10.000000000 Z
  zone: *1
  time: 2022-12-15 05:08:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-16 19:06:39.000000000 Z
  zone: *1
  time: 2022-12-16 19:06:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-18 21:49:36.000000000 Z
  zone: *1
  time: 2022-12-18 21:49:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-20 00:54:09.000000000 Z
  zone: *1
  time: 2022-12-20 00:54:09.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-22 21:51:31.000000000 Z
  zone: *1
  time: 2022-12-22 21:51:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-25 08:40:02.000000000 Z
  zone: *1
  time: 2022-12-25 08:40:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-26 22:01:45.000000000 Z
  zone: *1
  time: 2022-12-26 22:01:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2022-12-29 18:46:07.000000000 Z
  zone: *1
  time: 2022-12-29 18:46:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-01 01:55:31.000000000 Z
  zone: *1
  time: 2023-01-01 01:55:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-01 17:34:53.000000000 Z
  zone: *1
  time: 2023-01-01 17:34:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-04 09:05:13.000000000 Z
  zone: *1
  time: 2023-01-04 09:05:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-05 01:57:33.000000000 Z
  zone: *1
  time: 2023-01-05 01:57:33.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-06 08:56:47.000000000 Z
  zone: *1
  time: 2023-01-06 08:56:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-07 18:52:12.000000000 Z
  zone: *1
  time: 2023-01-07 18:52:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-08 00:43:40.000000000 Z
  zone: *1
  time: 2023-01-08 00:43:40.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-10 13:28:23.000000000 Z
  zone: *1
  time: 2023-01-10 13:28:23.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-13 10:22:38.000000000 Z
  zone: *1
  time: 2023-01-13 10:22:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-15 01:43:06.000000000 Z
  zone: *1
  time: 2023-01-15 01:43:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-15 04:30:52.000000000 Z
  zone: *1
  time: 2023-01-15 04:30:52.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-16 23:13:04.000000000 Z
  zone: *1
  time: 2023-01-16 23:13:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-19 17:16:31.000000000 Z
  zone: *1
  time: 2023-01-19 17:16:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-21 09:25:58.000000000 Z
  zone: *1
  time: 2023-01-21 09:25:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-23 09:42:42.000000000 Z
  zone: *1
  time: 2023-01-23 09:42:42.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-24 11:13:59.000000000 Z
  zone: *1
  time: 2023-01-24 11:13:59.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-25 00:57:26.000000000 Z
  zone: *1
  time: 2023-01-25 00:57:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-27 10:31:18.000000000 Z
  zone: *1
  time: 2023-01-27 10:31:18.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-28 07:08:54.000000000 Z
  zone: *1
  time: 2023-01-28 07:08:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-28 09:46:16.000000000 Z
  zone: *1
  time: 2023-01-28 09:46:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-30 04:34:32.000000000 Z
  zone: *1
  time: 2023-01-30 04:34:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-30 05:30:26.000000000 Z
  zone: *1
  time: 2023-01-30 05:30:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-01-31 08:08:44.000000000 Z
  zone: *1
  time: 2023-01-31 08:08:44.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-03 01:02:02.000000000 Z
  zone: *1
  time: 2023-02-03 01:02:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-03 10:02:38.000000000 Z
  zone: *1
  time: 2023-02-03 10:02:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-05 02:22:53.000000000 Z
  zone: *1
  time: 2023-02-05 02:22:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-05 05:55:46.000000000 Z
  zone: *1
  time: 2023-02-05 05:55:46.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-07 06:18:28.000000000 Z
  zone: *1
  time: 2023-02-07 06:18:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-08 13:57:28.000000000 Z
  zone: *1
  time: 2023-02-08 13:57:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-08 17:53:12.000000000 Z
  zone: *1
  time: 2023-02-08 17:53:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-10 08:40:27.000000000 Z
  zone: *1
  time: 2023-02-10 08:40:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-10 10:28:23.000000000 Z
  zone: *1
  time: 2023-02-10 10:28:23.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-12 15:42:42.000000000 Z
  zone: *1
  time: 2023-02-12 15:42:42.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-14 06:11:35.000000000 Z
  zone: *1
  time: 2023-02-14 06:11:35.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-14 12:22:06.000000000 Z
  zone: *1
  time: 2023-02-14 12:22:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-16 14:43:29.000000000 Z
  zone: *1
  time: 2023-02-16 14:43:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-16 15:58:19.000000000 Z
  zone: *1
  time: 2023-02-16 15:58:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-17 08:36:37.000000000 Z
  zone: *1
  time: 2023-02-17 08:36:37.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-19 04:20:36.000000000 Z
  zone: *1
  time: 2023-02-19 04:20:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-21 03:27:07.000000000 Z
  zone: *1
  time: 2023-02-21 03:27:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-22 09:09:23.000000000 Z
  zone: *1
  time: 2023-02-22 09:09:23.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-24 10:19:14.000000000 Z
  zone: *1
  time: 2023-02-24 10:19:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-26 13:28:50.000000000 Z
  zone: *1
  time: 2023-02-26 13:28:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-02-27 15:33:38.000000000 Z
  zone: *1
  time: 2023-02-27 15:33:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-01 14:48:42.000000000 Z
  zone: *1
  time: 2023-03-01 14:48:42.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-02 19:17:52.000000000 Z
  zone: *1
  time: 2023-03-02 19:17:52.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-03 09:48:41.000000000 Z
  zone: *1
  time: 2023-03-03 09:48:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-04 12:44:18.000000000 Z
  zone: *1
  time: 2023-03-04 12:44:18.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-06 18:24:47.000000000 Z
  zone: *1
  time: 2023-03-06 18:24:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-09 13:55:36.000000000 Z
  zone: *1
  time: 2023-03-09 13:55:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-11 13:50:26.000000000 Z
  zone: *1
  time: 2023-03-11 13:50:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-14 05:57:47.000000000 Z
  zone: *1
  time: 2023-03-14 05:57:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-14 09:16:38.000000000 Z
  zone: *1
  time: 2023-03-14 09:16:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-14 12:34:22.000000000 Z
  zone: *1
  time: 2023-03-14 12:34:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-14 15:15:53.000000000 Z
  zone: *1
  time: 2023-03-14 15:15:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-16 18:34:04.000000000 Z
  zone: *1
  time: 2023-03-16 18:34:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-19 13:01:38.000000000 Z
  zone: *1
  time: 2023-03-19 13:01:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-19 15:24:32.000000000 Z
  zone: *1
  time: 2023-03-19 15:24:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-20 14:56:28.000000000 Z
  zone: *1
  time: 2023-03-20 14:56:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-21 12:32:45.000000000 Z
  zone: *1
  time: 2023-03-21 12:32:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-23 22:16:22.000000000 Z
  zone: *1
  time: 2023-03-23 22:16:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-24 01:05:24.000000000 Z
  zone: *1
  time: 2023-03-24 01:05:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-26 12:01:36.000000000 Z
  zone: *1
  time: 2023-03-26 12:01:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-03-29 07:45:17.000000000 Z
  zone: *1
  time: 2023-03-29 07:45:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-01 06:03:31.000000000 Z
  zone: *1
  time: 2023-04-01 06:03:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-02 20:45:43.000000000 Z
  zone: *1
  time: 2023-04-02 20:45:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-03 05:33:10.000000000 Z
  zone: *1
  time: 2023-04-03 05:33:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-03 16:15:11.000000000 Z
  zone: *1
  time: 2023-04-03 16:15:11.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-05 14:56:49.000000000 Z
  zone: *1
  time: 2023-04-05 14:56:49.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-06 22:21:46.000000000 Z
  zone: *1
  time: 2023-04-06 22:21:46.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-08 19:50:51.000000000 Z
  zone: *1
  time: 2023-04-08 19:50:51.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-09 06:14:30.000000000 Z
  zone: *1
  time: 2023-04-09 06:14:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-09 11:26:27.000000000 Z
  zone: *1
  time: 2023-04-09 11:26:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-11 21:34:04.000000000 Z
  zone: *1
  time: 2023-04-11 21:34:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-14 08:51:06.000000000 Z
  zone: *1
  time: 2023-04-14 08:51:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-16 15:58:05.000000000 Z
  zone: *1
  time: 2023-04-16 15:58:05.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-17 03:06:43.000000000 Z
  zone: *1
  time: 2023-04-17 03:06:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-18 16:28:30.000000000 Z
  zone: *1
  time: 2023-04-18 16:28:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-18 17:32:38.000000000 Z
  zone: *1
  time: 2023-04-18 17:32:38.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-19 20:34:45.000000000 Z
  zone: *1
  time: 2023-04-19 20:34:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-22 06:16:01.000000000 Z
  zone: *1
  time: 2023-04-22 06:16:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-22 12:00:25.000000000 Z
  zone: *1
  time: 2023-04-22 12:00:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-24 21:12:27.000000000 Z
  zone: *1
  time: 2023-04-24 21:12:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-27 15:19:36.000000000 Z
  zone: *1
  time: 2023-04-27 15:19:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-29 00:43:46.000000000 Z
  zone: *1
  time: 2023-04-29 00:43:46.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-29 17:50:02.000000000 Z
  zone: *1
  time: 2023-04-29 17:50:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-04-30 05:22:14.000000000 Z
  zone: *1
  time: 2023-04-30 05:22:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-01 07:20:17.000000000 Z
  zone: *1
  time: 2023-05-01 07:20:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-03 05:11:16.000000000 Z
  zone: *1
  time: 2023-05-03 05:11:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-05 00:13:31.000000000 Z
  zone: *1
  time: 2023-05-05 00:13:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-05 12:08:33.000000000 Z
  zone: *1
  time: 2023-05-05 12:08:33.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-05 16:26:19.000000000 Z
  zone: *1
  time: 2023-05-05 16:26:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-07 23:53:00.000000000 Z
  zone: *1
  time: 2023-05-07 23:53:00.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-10 17:41:27.000000000 Z
  zone: *1
  time: 2023-05-10 17:41:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-12 01:37:24.000000000 Z
  zone: *1
  time: 2023-05-12 01:37:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-14 08:18:36.000000000 Z
  zone: *1
  time: 2023-05-14 08:18:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-16 15:17:43.000000000 Z
  zone: *1
  time: 2023-05-16 15:17:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-16 18:24:55.000000000 Z
  zone: *1
  time: 2023-05-16 18:24:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-19 16:16:45.000000000 Z
  zone: *1
  time: 2023-05-19 16:16:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-21 00:48:36.000000000 Z
  zone: *1
  time: 2023-05-21 00:48:36.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-22 00:54:41.000000000 Z
  zone: *1
  time: 2023-05-22 00:54:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-24 05:36:25.000000000 Z
  zone: *1
  time: 2023-05-24 05:36:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-25 10:05:39.000000000 Z
  zone: *1
  time: 2023-05-25 10:05:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-26 16:09:51.000000000 Z
  zone: *1
  time: 2023-05-26 16:09:51.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-29 12:40:29.000000000 Z
  zone: *1
  time: 2023-05-29 12:40:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-29 13:15:05.000000000 Z
  zone: *1
  time: 2023-05-29 13:15:05.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-05-31 15:28:14.000000000 Z
  zone: *1
  time: 2023-05-31 15:28:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-02 02:05:21.000000000 Z
  zone: *1
  time: 2023-06-02 02:05:21.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-02 13:05:50.000000000 Z
  zone: *1
  time: 2023-06-02 13:05:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-04 11:12:19.000000000 Z
  zone: *1
  time: 2023-06-04 11:12:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-05 10:04:34.000000000 Z
  zone: *1
  time: 2023-06-05 10:04:34.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-06 02:47:22.000000000 Z
  zone: *1
  time: 2023-06-06 02:47:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-07 04:35:17.000000000 Z
  zone: *1
  time: 2023-06-07 04:35:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-07 16:20:27.000000000 Z
  zone: *1
  time: 2023-06-07 16:20:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-08 07:43:14.000000000 Z
  zone: *1
  time: 2023-06-08 07:43:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-10 17:55:59.000000000 Z
  zone: *1
  time: 2023-06-10 17:55:59.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-12 17:00:02.000000000 Z
  zone: *1
  time: 2023-06-12 17:00:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-14 08:37:14.000000000 Z
  zone: *1
  time: 2023-06-14 08:37:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-14 18:07:30.000000000 Z
  zone: *1
  time: 2023-06-14 18:07:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-16 12:07:26.000000000 Z
  zone: *1
  time: 2023-06-16 12:07:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-18 22:29:39.000000000 Z
  zone: *1
  time: 2023-06-18 22:29:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-19 02:32:54.000000000 Z
  zone: *1
  time: 2023-06-19 02:32:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-20 14:24:40.000000000 Z
  zone: *1
  time: 2023-06-20 14:24:40.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-22 09:27:59.000000000 Z
  zone: *1
  time: 2023-06-22 09:27:59.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-23 07:31:20.000000000 Z
  zone: *1
  time: 2023-06-23 07:31:20.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-23 21:06:55.000000000 Z
  zone: *1
  time: 2023-06-23 21:06:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-26 06:57:28.000000000 Z
  zone: *1
  time: 2023-06-26 06:57:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-28 17:08:12.000000000 Z
  zone: *1
  time: 2023-06-28 17:08:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-29 03:06:47.000000000 Z
  zone: *1
  time: 2023-06-29 03:06:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-06-30 12:25:41.000000000 Z
  zone: *1
  time: 2023-06-30 12:25:41.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-02 08:49:42.000000000 Z
  zone: *1
  time: 2023-07-02 08:49:42.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-03 20:09:26.000000000 Z
  zone: *1
  time: 2023-07-03 20:09:26.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-06 17:39:13.000000000 Z
  zone: *1
  time: 2023-07-06 17:39:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-09 00:18:52.000000000 Z
  zone: *1
  time: 2023-07-09 00:18:52.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-11 03:58:21.000000000 Z
  zone: *1
  time: 2023-07-11 03:58:21.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-12 22:37:00.000000000 Z
  zone: *1
  time: 2023-07-12 22:37:00.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-14 01:58:44.000000000 Z
  zone: *1
  time: 2023-07-14 01:58:44.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-16 20:21:13.000000000 Z
  zone: *1
  time: 2023-07-16 20:21:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-17 01:41:47.000000000 Z
  zone: *1
  time: 2023-07-17 01:41:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-19 10:06:35.000000000 Z
  zone: *1
  time: 2023-07-19 10:06:35.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-21 17:44:16.000000000 Z
  zone: *1
  time: 2023-07-21 17:44:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-22 02:46:04.000000000 Z
  zone: *1
  time: 2023-07-22 02:46:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-22 06:52:04.000000000 Z
  zone: *1
  time: 2023-07-22 06:52:04.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-23 04:53:49.000000000 Z
  zone: *1
  time: 2023-07-23 04:53:49.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-25 16:37:24.000000000 Z
  zone: *1
  time: 2023-07-25 16:37:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-27 18:34:33.000000000 Z
  zone: *1
  time: 2023-07-27 18:34:33.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-28 02:34:02.000000000 Z
  zone: *1
  time: 2023-07-28 02:34:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-29 19:53:32.000000000 Z
  zone: *1
  time: 2023-07-29 19:53:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-07-30 23:30:11.000000000 Z
  zone: *1
  time: 2023-07-30 23:30:11.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-02 17:46:22.000000000 Z
  zone: *1
  time: 2023-08-02 17:46:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-03 00:01:21.000000000 Z
  zone: *1
  time: 2023-08-03 00:01:21.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-03 03:57:56.000000000 Z
  zone: *1
  time: 2023-08-03 03:57:56.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-03 21:41:28.000000000 Z
  zone: *1
  time: 2023-08-03 21:41:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-04 23:37:31.000000000 Z
  zone: *1
  time: 2023-08-04 23:37:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-05 08:20:42.000000000 Z
  zone: *1
  time: 2023-08-05 08:20:42.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-07 21:01:55.000000000 Z
  zone: *1
  time: 2023-08-07 21:01:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-10 17:03:47.000000000 Z
  zone: *1
  time: 2023-08-10 17:03:47.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-11 21:06:31.000000000 Z
  zone: *1
  time: 2023-08-11 21:06:31.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-12 08:45:08.000000000 Z
  zone: *1
  time: 2023-08-12 08:45:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-13 07:09:39.000000000 Z
  zone: *1
  time: 2023-08-13 07:09:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-14 11:15:10.000000000 Z
  zone: *1
  time: 2023-08-14 11:15:10.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-16 04:15:48.000000000 Z
  zone: *1
  time: 2023-08-16 04:15:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-19 04:11:43.000000000 Z
  zone: *1
  time: 2023-08-19 04:11:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-19 10:10:27.000000000 Z
  zone: *1
  time: 2023-08-19 10:10:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-22 09:41:20.000000000 Z
  zone: *1
  time: 2023-08-22 09:41:20.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-24 10:27:08.000000000 Z
  zone: *1
  time: 2023-08-24 10:27:08.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-24 18:16:12.000000000 Z
  zone: *1
  time: 2023-08-24 18:16:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-25 17:02:28.000000000 Z
  zone: *1
  time: 2023-08-25 17:02:28.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-27 15:58:52.000000000 Z
  zone: *1
  time: 2023-08-27 15:58:52.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-27 23:29:53.000000000 Z
  zone: *1
  time: 2023-08-27 23:29:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-28 21:31:27.000000000 Z
  zone: *1
  time: 2023-08-28 21:31:27.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-29 03:35:29.000000000 Z
  zone: *1
  time: 2023-08-29 03:35:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-08-31 06:15:19.000000000 Z
  zone: *1
  time: 2023-08-31 06:15:19.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-01 21:56:52.000000000 Z
  zone: *1
  time: 2023-09-01 21:56:52.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-02 22:57:53.000000000 Z
  zone: *1
  time: 2023-09-02 22:57:53.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-05 03:28:30.000000000 Z
  zone: *1
  time: 2023-09-05 03:28:30.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-07 04:57:12.000000000 Z
  zone: *1
  time: 2023-09-07 04:57:12.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-09 19:16:05.000000000 Z
  zone: *1
  time: 2023-09-09 19:16:05.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-09 20:01:39.000000000 Z
  zone: *1
  time: 2023-09-09 20:01:39.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-11 03:23:22.000000000 Z
  zone: *1
  time: 2023-09-11 03:23:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-12 15:18:29.000000000 Z
  zone: *1
  time: 2023-09-12 15:18:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-13 14:14:43.000000000 Z
  zone: *1
  time: 2023-09-13 14:14:43.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-13 17:37:25.000000000 Z
  zone: *1
  time: 2023-09-13 17:37:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-14 18:17:49.000000000 Z
  zone: *1
  time: 2023-09-14 18:17:49.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-16 19:56:55.000000000 Z
  zone: *1
  time: 2023-09-16 19:56:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-18 14:21:02.000000000 Z
  zone: *1
  time: 2023-09-18 14:21:02.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-21 00:34:13.000000000 Z
  zone: *1
  time: 2023-09-21 00:34:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-23 07:14:06.000000000 Z
  zone: *1
  time: 2023-09-23 07:14:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-24 17:22:22.000000000 Z
  zone: *1
  time: 2023-09-24 17:22:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-27 12:42:54.000000000 Z
  zone: *1
  time: 2023-09-27 12:42:54.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-09-28 14:48:45.000000000 Z
  zone: *1
  time: 2023-09-28 14:48:45.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-01 11:54:24.000000000 Z
  zone: *1
  time: 2023-10-01 11:54:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-03 07:36:32.000000000 Z
  zone: *1
  time: 2023-10-03 07:36:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-05 05:13:57.000000000 Z
  zone: *1
  time: 2023-10-05 05:13:57.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-06 16:07:06.000000000 Z
  zone: *1
  time: 2023-10-06 16:07:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-09 00:03:52.000000000 Z
  zone: *1
  time: 2023-10-09 00:03:52.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-09 02:32:01.000000000 Z
  zone: *1
  time: 2023-10-09 02:32:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-10 16:39:07.000000000 Z
  zone: *1
  time: 2023-10-10 16:39:07.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-12 13:28:16.000000000 Z
  zone: *1
  time: 2023-10-12 13:28:16.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-14 04:29:14.000000000 Z
  zone: *1
  time: 2023-10-14 04:29:14.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-17 03:30:24.000000000 Z
  zone: *1
  time: 2023-10-17 03:30:24.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-20 03:13:15.000000000 Z
  zone: *1
  time: 2023-10-20 03:13:15.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-20 20:47:06.000000000 Z
  zone: *1
  time: 2023-10-20 20:47:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-21 13:59:34.000000000 Z
  zone: *1
  time: 2023-10-21 13:59:34.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-23 21:38:48.000000000 Z
  zone: *1
  time: 2023-10-23 21:38:48.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-24 06:07:13.000000000 Z
  zone: *1
  time: 2023-10-24 06:07:13.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-25 22:51:17.000000000 Z
  zone: *1
  time: 2023-10-25 22:51:17.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-26 21:12:50.000000000 Z
  zone: *1
  time: 2023-10-26 21:12:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-28 05:52:20.000000000 Z
  zone: *1
  time: 2023-10-28 05:52:20.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-29 22:11:01.000000000 Z
  zone: *1
  time: 2023-10-29 22:11:01.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-10-30 12:29:25.000000000 Z
  zone: *1
  time: 2023-10-30 12:29:25.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-02 02:52:55.000000000 Z
  zone: *1
  time: 2023-11-02 02:52:55.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-02 06:00:32.000000000 Z
  zone: *1
  time: 2023-11-02 06:00:32.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-03 08:39:06.000000000 Z
  zone: *1
  time: 2023-11-03 08:39:06.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-04 23:51:22.000000000 Z
  zone: *1
  time: 2023-11-04 23:51:22.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-07 16:11:33.000000000 Z
  zone: *1
  time: 2023-11-07 16:11:33.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-10 10:55:29.000000000 Z
  zone: *1
  time: 2023-11-10 10:55:29.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-12 01:20:18.000000000 Z
  zone: *1
  time: 2023-11-12 01:20:18.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-12 04:22:50.000000000 Z
  zone: *1
  time: 2023-11-12 04:22:50.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-12 08:38:58.000000000 Z
  zone: *1
  time: 2023-11-12 08:38:58.000000000 Z
- !ruby/object:ActiveSupport::TimeWithZone
  utc: 2023-11-13 15:43:40.000000000 Z
  zone: *1
  time: 2023-11-13 15:43:40.000000000 Z
