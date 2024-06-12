---
title: Calendar
categories:
  - Backend
  - Extra
image: none
---

# Calendar Extra

Add pagination filtering by calendar time unit: year, quarter, month, week, day and your
own [custom time units](/docs/api/calendar.md#custom-units).

This extra adds single or multiple chained calendar navs that act as calendar filters on the collection records, placing each
record in its time unit.

![calendar_app](/docs/assets/images/calendar-app.png)

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#4-calendar-app)

## Use cases

This extra makes sense when the result to paginate have some _time continuity_ and you want to provide a simple chronological
browsing. For example: a movie catalog could allow the user to browse all the movies by year, or you may want to browse a long
list of events by jumping and narrowing between years, months, days.

On the other hand it does not make much sense for the result of a search that hits just a few sparse records scattered over a
possibly long period of time. For that case the calendar extra has an `:active` flag that can be used to inactivate the calendar
and fallback to the regular pagination. No need to maintain different UIs for wide browsing and narrow searching.

## Synopsis

```ruby initializer (pagy.rb)
require 'pagy/extras/calendar'
```

```ruby controller
# e.g. application_controller.rb
def pagy_calendar_period(collection)
  return_period_array_using(collection)
end

# e.g. application_controller.rb
def pagy_calendar_filter(collection, from, to)
  return_filtered_collection_using(collection, from, to)
end

# some action:
def index
  @calendar, @pagy, @records = pagy_calendar(collection, year: { size: [1, 1, 1, 1], ... },
                                             month:            { size: [0, 12, 12, 0], ... },
                                             pagy:             { items: 10, ... })
end
```

```erb view (template)
<!-- calendar filtering -->
<%== pagy_nav(@calendar[:year]) %>
<%== pagy_nav(@calendar[:month]) %>

<!-- pagy info extended for the calendar unit -->
<%== pagy_info(@pagy) %> for <%== @calendar[:month].label(format: '%B %Y') %>

... display @records ...

<!-- standard pagination of the selected month -->
<%== pagy_nav(@pagy) %>
```

See also a few examples
about [How to wrap existing pagination with pagy_calendar](/docs/how-to.md#wrap-existing-pagination-with-pagy_calendar).

## Usage

Since the time can be stored or calculated in many different ways in different collections, this extra requires you to implement a
couple of simple methods in your app and configure the objects that it creates and coordinates for you.

The whole usage boils down to these steps:

1. Configure the [pagy_calendar](#pagy-calendar-collection-configuration) method in your action
2. Define the [pagy_calendar_period](#pagy-calendar-period-collection) method in your controller
3. Define the [pagy_calendar_filter](#pagy-calendar-filter-collection-from-to) method in your controller
4. Use it in your UI

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#4-calendar-app)

## Variables and Accessors

See [Pagy::Calendar](/docs/api/calendar.md#variables)

## Methods

All the methods in this module are prefixed with the `"pagy_calendar"` string in order to avoid any possible conflict with your
own methods when you include the module in your controller. They are also all private, so they will not be available as actions.

==- `pagy_calendar(collection, configuration)`

This method wraps one or more levels of calendar filtering on top of another backend pagination method (
e.g. `pagy`, `pagy_arel`, `pagy_array`, `pagy_searchkick`, `pagy_elasticsearch_rails`, `pagy_meilisearch`, ...).

It filters the `collection` by the selected time units in the `configuration` (e.g. `year`, `month`, `day`, ...), and forwards it
to the wrapped method.

It returns an array with one more item than the usual two:

```ruby controller
@calendar, @pagy, @results = pagy_calendar(...)
```

The `@calendar` is the hash of the generated `Pagy::Calendar::*` objects that can be used in the UI.

It also provides the `showtime` helper method that returns the `DateTime` of the smallest time unit currently shown in your
calendar. For example:

```erb
<!-- Link to go to a specific page in the calendar -->
<a href="<%= pagy_calendar_url_at(@calendar, Time.zone.parse('2022-03-03')) %>">Go to the 2022-03 Page</a>

<!-- Showtime shows the `DateTime` beginning of the smallest time unit currently shown in the calendar -->
<p>Showtime: <%= @calendar.showtime %></p>
```

### `collection` argument

The `collection` argument (from `ActiveRecord`, `ElasticSearchRails`, `Searchkick`, `Meilisearch`, ...) is filtered by
the `pagy_calendar_filter` and forwarded to the wrapped method for its final pagination, so ensure that you pass the same type of
argument expected by the wrapped method.

### `configuration` argument

The `configuration` argument must be a Hash structure with the keys representing the type of configuration and the values being
the Hash of the variables that you want to pass for the creation of the specific pagy object (or a `boolean` for
the [Active flag](#active-flag)).

The `configuration` hash can be composed by the following types of configuration:

#### Calendar configuration

The calendar configuration determines the calendar objects generated. These are used for filtering the collection to the selected
time units.

You can add one or more levels with keys like `:year`, `:quarter`, `:month`, `:week`, `:day`. Each key must be set to the hash of
the variables that will be used to initialize the relative `Pagy::Calendar::*` object. Use an empty hash for default values.
E.g.: `year: {}, month: {}, ...`.

!!!warning Do not set `:page`, `:page_param`, `:params` and `:period` keys
The `:page`, `:page_param`, `:params` and `:period` variables for the calendar objects are managed automatically by the extra.
Setting them explicitly has no effect. (See also [Calendar params](#calendar-params) for solutions in case of conflicts)
!!!

#### Pagy configuration

This is the optional configuration of the final pagination object (produced by the wrapped method) which is always used regardless
the value of the [Active flag](#active-flag).

You can pass one optional `:pagy` key, set to the hash of the variables to initialize the `Pagy` object. It has none of the
restriction mentioned in the [Calendar configuration](#calendar-configuration).

Besides the usual pagy variables, you can add a `:backend` variable, set to the name of the backend extra method that you want to
use for managing the collection:

```ruby
{ pagy: { backend: :pagy_searchkick, items: 10, ... } }
```

Notice that the `collection` argument must be exactly what you would pass to the wrapped backend method.

If the `:pagy` key/value is omitted, a default `Pagy` instance will be created by the default `:pagy` backend method.

#### Active flag

The calendar is active by default, however you can add an optional `:active` boolean flag to the `configuration` hash in order to
switch it ON or OFF, depending on its usefulness in different conditions (see the [Use cases](#use-cases)).

==- `pagy_calendar_period(collection)`

!!!primary Must implement
This method must be implemented by the application.
!!!

It receives a `collection` argument that must not be changed by the method, but can be used to return the starting and ending
local `TimeWithZone` objects array defining the calendar `:period`. See
the [Pagy::Calendar Variables](/docs/api/calendar.md#variables) for details.

Depending on the type of storage, the `collection` argument can contain a different kind of object:

#### ActiveRecord managed storage

If you use `ActiveRecord` the `collection` is going to be an `ActiveRecord::Relation` object. You can use it to return the
starting and ending local `TimeWithZone` objects array. Here are a few examples with the `created_at` field (but you can pull the
time from anywhere):

```ruby  Controller
# Simpler version (2 queries)
def pagy_calendar_period(collection)
  starting = collection.minimum('created_at')
  ending   = collection.maximum('created_at')
  [starting.in_time_zone, ending.in_time_zone]
end

# Faster version with manual pluck (1 query)
def pagy_calendar_period(collection)
  minmax = collection.pluck('MIN(created_at)', 'MAX(created_at)').first
  minmax.map { |time| Time.parse(time).in_time_zone }
end

# Fastest version (no queries)
# If you have the starting and ending times in the request (from UI selectors), 
# filter the collection by the param before passing it to `pagy_calendar`. 
# In this example you just use the :starting and :ending params to return the period
def pagy_calendar_period(collection)
  params.fetch_values(:starting, :ending).map { |time| Time.parse(time).in_time_zone }
end
```

See also [Time conversion](/docs/api/calendar.md#time-conversions) for details.

#### Search frameworks storage

_If you use `ElasticSearchRails`, `Searchkick`, `Meilisearch` the `collection` argument is just the Array of the captured search
arguments that you passed to the `Model.pagy_search` method. That array is what pagy uses internally to setup its variables before
passing it to the standard `Model.search` method to do the actual search._

So you should use what you need from the `collection` array and do your own `Model.search(...)` in order to get the starting and
ending local `TimeWithZone` objects array to return.

==- `pagy_calendar_filter(collection, from, to)`

!!!primary Must implement
This method must be implemented by the application.
!!!

It receives the main `collection` and must return a filtered version of it using the `from` and `to` **local Time** objects.

You should filter your collection with a logic equivalent to `storage_time >= from && storage_time < to`, adapted to the time zone
and syntax of your storage.

Depending on the type of storage, the `collection` argument can contain a different kind of object:

#### ActiveRecord managed storage

If you use `ActiveRecord` the `collection` is going to be an `ActiveRecord::Relation` object that you can easily filter. Here is
an example with the `created_at` field again (but you can use anything, of course):

```ruby controller

def pagy_calendar_filter(collection, from, to)
  collection.where(created_at: from...to) # 3-dots range excluding the end value
end
```

See also [Time conversion](/docs/api/calendar.md#time-conversions) for details.

#### Search frameworks storage

_If you use `ElasticSearchRails`, `Searchkick`, `Meilisearch` the `collection` argument is just the Array of the captured search
arguments that you passed to the `Model.pagy_search` method. That array is what pagy uses internally to setup its variables before
passing it to the standard `Model.search` method to do the actual search._

So in order to filter the actual search with the `from` and `to` local `TimeWithZone` objects, you should simply return the same array with the filtering added to its relevant item. Pagy will use it to do the actual (filtered) search.
===

## Customization

### Order

If you set `:order` to `:desc`, you will get the page units in descendent order (e.g. May, then April, then March, ...), but keep
in mind that you still have to desc-order the records in the collection since pagy has no control over that (indeed it's your own
collection scope).

```ruby controller
@calendar, @pagy, @records = pagy_calendar(collection.desc_scope,
                                           year: {order: :desc},
                                           month: {order: :desc})
```

### Beginning of week

If you use the `:week` time unit, consider that the first day of the week could be different for different locales.

You may want to adjust it by setting the `Date.beginning_of_week` variable to the symbol of the first day of the week (
e.g. `Date.beginning_of_week = :sunday`). Notice the default is `:monday` consistently with the ISO-8601 standard (and Rails).

### Calendar params

This extra handles the request params of its objects automatically, and you should not need to customize them unless they conflict
with other params in your requests. In that case you have a couple of alternatives:

- Renaming the conflicting param of your app
- Passing a custom `:page_param` to the [Pagy configuration](#pagy-configuration). That will internally rename the `:page_param`
  vars and update the `:params` procs of all the calendar objects accordingly.

## View

You can use the calendar objects with any `pagy_*nav` and `pagy_*nav_js` helpers in your views.

The `pagy_*combo_nav_js` keeps into account only page numbers and not labels, so it is not very useful (if at all)
with `Pagy::Calendar::*` objects.

==- `pagy_calendar_url_at(@calendar, time, **opts)`

This helper takes the `@calendar` and a `TimeWithZone` objects and returns the url complete with all the params for the pages in
each bars that include the passed time.

For example: `pagy_calendar_url_at(@calendar, Time.zone.now)` will select the the bars pointing to today.

If `time` is outside the pagination range it raises a `Pagy::Calendar::OutOfRangeError`, however you can pass the
option `fit_time: true` to avoid the error and get the url to the page closest to the passed time argument (first or last page).

===

### Label format

Each page link in the calendar navs is conveniently labeled with the specific `Time` period it refers to. You can change the time
format to your needs by setting the `:format` variable to a standard `strftime` format. (See
the [Pagy::Calendar variables](/docs/api/calendar.md#variables))

You can also get the [label method](/docs/api/calendar.md#methods) with e.g.: `@calendar[:month].label`, which might be useful to
use in your UI.

### I18n localization

Pagy implements its own faster version of the i18n `translate` method (see [pagy_t](/docs/api/frontend/#pagy-t-key-vars)), but
does not provide any built-in `localize` method. If you need localization of calendar labels in other locales, you should delegate
it to the `I18n` gem, so that a change in the global `I18n.locale` will automatically localize all the time labels accordingly.

You have a couple of options:

- Use the [i18n extra](i18n.md), which delegates the translation and localization to the `I18n` gem. Notice however that you would
  lose the performance gain offered by the built-in `pagy_t` translation.
- Uncomment the block in the calendar section in the pagy initializer, which will add the localization from the `I18n` gem without
  using the [i18n extra](/docs/extras/i18n.md), so preserving the builtin `pagy_t` translation.

## Caveats

!!!warning Display Message when empty
Calendar pages with no records are accessible but empty: you may want to display some message when `@records.empty?`.
!!!
