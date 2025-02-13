---
title: pagy_calendar
categories:
  - Backend
  - Paginators
image: none
---

!!!warning Active Support Required!
!!!

`pagy_calendar` is a compund `time-range` and `OFFSET` paginator, that can add any combination of filtering by calendar time unit
_(year, quarter, month, week, and day)_ to the pagination

![calendar_app](/docs/assets/images/calendar-app.png)

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/playground.md#4-calendar-app)

!!!success Use this paginator when the results have mostly populated pages/time-units.
!!!
!!!danger Don't use it for sparse records with many empty pages.
!!!

```ruby
  @calendar, @pagy, @records = pagy_calendar(collection,
                                             year:  {},
                                             month: {})

```

- `@calendar` is a special hash containing the pagy time unit objects (in this case `:year` and `:month`)
- `@pagy` is the object of the page of records
- `@records` is the paginated collection
- `:year`, `:month` arguments create the time unit objects (they use default options in the example)

==- Usage

This extra requires you to implement a couple of simple methods in your app and configure the objects that it creates and
coordinates for you.

```ruby Controller
# All time values must be ActiveSupport::TimeWithZone

# REQUIRED: return the start and end limits of the collection as a 2 items array
def pagy_calendar_period(collection)
  starting = collection.minimum(:created_at)
  ending   = collection.maximum(:created_at)
  [starting.in_time_zone, ending.in_time_zone]
end

# REQUIRED: return the collection filtered by a time period
def pagy_calendar_filter(collection, from, to)
  collection.where(created_at: from...to)
end

# OPTIONAL: return the array counts per time
def pagy_calendar_counts(collection, unit, from, to)
  collection.group_by_period(unit, :created_at, range: from...to).count.values
end

# Example of usage. Relies on defaults.
def index
  @calendar, @pagy, @records = pagy_calendar(collection,
                                             year:  {},
                                             month: {},
                                             pagy:  {})
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

===
<details>
<summary class="a4" style="font-weight: bold">In-Depth Documentation</summary>

<br/>

### Methods

==- `pagy_calendar(collection, configuration)`

This method wraps one or more levels of calendar filtering on top of another backend pagination method (
e.g. `pagy_searchkick`, `pagy_elasticsearch_rails`, `pagy_meilisearch`, ...).

It filters the `collection` by the selected time units in the `configuration` (e.g. `year`, `month`, `day`, ...), and forwards it
to the wrapped method.

It returns an array with one more item than the usual two:

```ruby controller
@calendar, @pagy, @results = pagy_calendar(...)
```

The `@calendar` is the hash of the generated unit objects that can be used in the UI.

It also provides the `showtime` helper method that returns the time of the smallest time unit currently shown in your calendar.
For example:

```erb
<!-- Link to go to a specific page in the calendar -->
<a href="<%= pagy_calendar_url_at(@calendar, Time.zone.parse('2022-03-03')) %>">Go to the 2022-03 Page</a>

<!-- Showtime shows the `DateTime` beginning of the smallest time unit currently shown in the calendar -->
<p>Showtime: <%= @calendar.showtime %></p>
```

#### `collection` argument
<br/>

The `collection` argument (from `ActiveRecord`, `ElasticSearchRails`, `Searchkick`, `Meilisearch`, ...) is filtered by the
`pagy_calendar_filter` and forwarded to the wrapped method for its final pagination, so ensure that you pass the same type of
argument expected by the wrapped method.

#### `configuration` argument
<br/>

The `configuration` argument must be a Hash structure with the keys representing the type of configuration and the values being
the Hash of the options that you want to pass for the creation of the specific pagy object (or a `boolean` for
the [Active flag](#active-flag)).

The `configuration` hash can be composed by the following types of configuration:

##### Calendar configuration
<br/>

The calendar configuration determines the calendar objects generated. These are used for filtering the collection to the selected
time units.

You can add one or more levels with keys like `:year`, `:quarter`, `:month`, `:week`, `:day`. Each key must be set to the hash of
the options that will be used to initialize the relative `Pagy::Calendar::*` object. Use an empty hash for default values. E.g.:
`year: {}, month: {}, ...`.

!!!warning Do not set `:page`, `:page_sym`, `:params` and `:period` keys That options for the calendar objects are managed
automatically by the extra. Setting them explicitly has no effect. (See also [Calendar params](#calendar-params) for solutions in
case of conflicts)
!!!

##### Pagy configuration
<br/>

This is the optional configuration of the final pagination object (produced by the wrapped method) which is always used regardless
the value of the [Active flag](#active-flag).

You can pass one optional `:pagy` key, set to the hash of the options to initialize the `Pagy` object. It has none of the
restriction mentioned in the [Calendar configuration](#calendar-configuration).

Besides the usual pagy options, you can add a `:backend` option, set to the name of the backend extra method that you want to use
for managing the collection:

```ruby
{ pagy: { backend: :pagy_searchkick, limit: 10, ... } }
```

Notice that the `collection` argument must be exactly what you would pass to the wrapped backend method.

If the `:pagy` key/value is omitted, a default `Pagy` instance will be created by the default `:pagy` backend method.

##### Active flag
<br/>

The calendar is active by default, however you can add an optional `:active` boolean flag to the `configuration` hash in order to
switch it ON or OFF, depending on its usefulness in different conditions (see the [Use cases](#use-cases)).

==- `pagy_calendar_period(collection)`

!!!primary Must implement This method must be implemented by the application.
!!!

It receives a `collection` argument that must not be changed by the method, but can be used to return the starting and ending
local `TimeWithZone` objects array defining the calendar `:period`. See
the [Pagy::Calendar Variables](/docs/api/calendar.md#options) for details.

Depending on the type of storage, the `collection` argument can contain a different kind of object:

##### ActiveRecord managed storage
<br/>

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
  minmax = collection.pick('MIN(created_at)', 'MAX(created_at)')
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

##### Search frameworks storage
<br/>

_If you use `ElasticSearchRails`, `Searchkick`, `Meilisearch` the `collection` argument is just the Array of the captured search
arguments that you passed to the `Model.pagy_search` method. That array is what pagy uses internally to setup its options before
passing it to the standard `Model.search` method to do the actual search._

So you should use what you need from the `collection` array and do your own `Model.search(...)` in order to get the starting and
ending local `TimeWithZone` objects array to return.

==- `pagy_calendar_filter(collection, from, to)`

!!!primary Must implement This method must be implemented by the application.
!!!

It receives the main `collection` and must return a filtered version of it using the `from` and `to` **local Time** objects.

You should filter your collection with a logic equivalent to `storage_time >= from && storage_time < to`, adapted to the time zone
and syntax of your storage.

Depending on the type of storage, the `collection` argument can contain a different kind of object:

##### ActiveRecord managed storage
<br/>

If you use `ActiveRecord` the `collection` is going to be an `ActiveRecord::Relation` object that you can easily filter. Here is
an example with the `created_at` field again (but you can use anything, of course):

```ruby Controller
def pagy_calendar_filter(collection, from, to)
  collection.where(created_at: from...to) # 3-dots range excluding the end value
end
```

See also [Time conversion](/docs/api/calendar.md#time-conversions) for details.

##### Search frameworks storage
<br/>

_If you use `ElasticSearchRails`, `Searchkick`, `Meilisearch` the `collection` argument is just the Array of the captured search
arguments that you passed to the `Model.pagy_search` method. That array is what pagy uses internally to setup its options before
passing it to the standard `Model.search` method to do the actual search._

So in order to filter the actual search with the `from` and `to` local `TimeWithZone` objects, you should simply return the same
array with the filtering added to its relevant item. Pagy will use it to do the actual (filtered) search.

==- `pagy_calendar_counts(collection, unit, from, to)`

!!!primary Optional implementation This method can be implemented by the application in order to add some UI feedback to the pagy
nav links
!!!

If this method is defined, pagy will run it for each used calendar unit and will add an extra `empty-page`
CSS class to the links to empty pages (that can be targeted to give a visual UI feedback). Pagy will also add a `title`
attribute to display a tooltip info for each page link.

The method receives the main `collection`, the `unit` symbol, and must return the array of the counts grouped by unit using the
`from` and `to` **local Time** objects.

If your collection is an `ActiveRecord::Relation` object you won't have to do much: just add the
[groupdate gem](https://github.com/ankane/groupdate) to your bundle and use the following one liner (just change the
`:created_at` to the time field you need):

```ruby Controller
def pagy_calendar_counts(collection, unit, from, to)
  collection.group_by_period(unit, :created_at, range: from...to).count.values
end
```

For other types of collection you should override the method.

!!!warning Extra queries required

The extra feedback triggered by this method executes one extra count query per unit, (e.g. with a year + month calendar there are
2 extra queries). That is usually OK for most environments, but it might be slow on others, so check it on your actual DB in order
to evaluate the performance.

If you want to use it dynamically, you can skip the extra query and the relative feedback by returning `nil` when you need it.
!!!

===

### Customization

#### Order

If you set `:order` to `:desc`, you will get the page units in descendent order (e.g. May, then April, then March, ...), but keep
in mind that you still have to desc-order the records in the collection since pagy has no control over that (indeed it's your own
collection scope).

```ruby controller
@calendar, @pagy, @records = pagy_calendar(collection.desc_scope,
                                           year:  { order: :desc },
                                           month: { order: :desc })
```

#### Beginning of week

If you use the `:week` time unit, consider that the first day of the week could be different for different locales.

You may want to adjust it by setting the `Date.beginning_of_week` option to the symbol of the first day of the week (
e.g. `Date.beginning_of_week = :sunday`). Notice the default is `:monday` consistently with the ISO-8601 standard (and Rails).

#### Calendar params

`pagy_calendar` handles the request params of its objects automatically, and you should not need to customize them unless they conflict
with other params in your requests. In that case you have a couple of alternatives:

- Renaming the conflicting param of your app
- Passing a custom `:page_sym` to the [Pagy configuration](#pagy-configuration). That will internally rename the `:page_sym`
  opts and update the `:params` procs of all the calendar objects accordingly.

### View

You can use the calendar objects with any `pagy_*nav` and `pagy_*nav_js` helpers in your views.

The `pagy_*combo_nav_js` keeps into account only page numbers and not labels, so it is not very useful (if at all)
with `Pagy::Calendar::*` objects.

==- `pagy_calendar_url_at(@calendar, time, **opts)`

This helper takes the `@calendar` and a `TimeWithZone` objects and returns the url complete with all the params for the pages in
each filter bar that include the passed time.

For example: `pagy_calendar_url_at(@calendar, Time.zone.now)` selects the filter bars pointing to today.

If `time` is outside the pagination range it raises a `Pagy::RangeError`, however you can pass the option
`fit_time: true` to avoid the error and get the url to the page closest to the passed time argument (first or last page).

===

#### Label format

Each page link in the calendar navs is conveniently labeled with the specific `Time` period it refers to. You can change the time
format to your needs by passing the `:format` option, set to a standard `strftime` format, to the time unit option argument.

```ruby controller
@calendar, @pagy, @records = pagy_calendar(collection.desc_scope,
                                           year:  { format: '...' },
                                           month: { format: '...' })
```
You can also get the [label method](/docs/api/calendar.md#methods) with e.g.: `@calendar[:month].label`, which might be useful to
use in your UI.

#### I18n localization

Uncomment the block in the calendar section in the pagy initializer.

### Caveats

!!!warning Display Message when empty Calendar pages with no records are accessible but empty: you may want to display some
message when `@records.empty?`.
!!!

</details>
