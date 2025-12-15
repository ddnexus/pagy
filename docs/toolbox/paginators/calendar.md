---
label: :calendar
icon: calendar-24
order: 60
image: ""
categories:
  - Paginators
---

#

## :icon-calendar: :calendar

---

!!!warning ActiveSupport Required!
!!!

The `:calendar` paginator combines the functionality of `time-range` with the `OFFSET` pagination.

It enables cascade-filtering of the collection by time units _(year, quarter, month, week, and day)_, followed by paginating the filtered collection using the `:offset` paginator.

![calendar_app](/assets/images/calendar-app.png){with=721}

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#calendar-app)

!!!success Use this paginator when most pages contain results.
!!!

!!!warning Avoid using it for sparse datasets with numerous empty pages.
!!!

```ruby
  @calendar, @pagy, @records = pagy(:calendar, collection, year: {}, month: {}, offset: {})
```

- `@calendar` is a specialized hash that contains the pagy time unit objects (e.g., `:year` and `:month` in this example).
- `@pagy` is the object representing the current page of records.
- `@records` is the paginated subset of the collection.
- The `:year` and `:month` parameters create time unit objects (default options are used in this example).
- `:offset` is the offset instance that paginates the time-filtered collection.

==- Usage

You must define a few simple methods in your app to configure and coordinate the objects created by the `pagy` method. Se the following examples and comments (adapted from the [Calendar app code](../../sandbox/playground.md/#calendar-app))

```ruby Controller
# Note: All time values must be instances of ActiveSupport::TimeWithZone.
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

# OPTIONAL: return the array of counts per time unit
# If this method is defined, pagy  will add an extra 'empty-page' CSS class 
# to the links leading to empty pages, along with a title attribute containing information about each page link.
def pagy_calendar_counts(collection, unit, from, to)
  # If collection is in order: :desc, add the reverse: true option to the next line
  collection.group_by_period(unit, :created_at, range: from...to).count.values
end

# Example usage with default options.
def index
  @calendar, @pagy, @records = pagy(:calendar, collection,
                                    year:  {},
                                    month: {},
                                    offset: {})
end
```

```erb view (template)
<!-- Calendar filtering -->
<%== @calendar[:year].nav %>
<%== @calendar[:month].nav %>

<!-- Pagy info extended for the calendar unit -->
<%== @pagy.info %> for <%== @calendar[:month].page_label(@pagy.page, format: '%B %Y') %>.

... Render @records here ...

<!-- Standard pagination for the selected month -->
<%== @pagy.nav %>

<p>Showtime: <%= @calendar.showtime %></p>
<a href="<%= @calendar.url_at(Time.zone.now) %>">Go to now</a>
```

==- Calendar Configuration

The calendar configuration defines the calendar objects to be generated. These objects filter the collection by the selected time units.

You can include one or more Unit levels using keys like `:year`, `:quarter`, `:month`, `:week`, or `:day`. Assign each key a hash of unit options. Use an empty hash for default values, e.g., `year: {}, month: {}, ...`.

!!!warning Option restrictions

Do not try to set `:page`, `:page_key`, `:querify`, or `:period` options manually. These options are handled automatically, so setting them explicitly has no effect.

The `Pagy.options` are not applied to the Unit objects.
!!!
 
#### The `disabled` flag

<br/>

The calendar is enabled by default. However, you can include an optional `:disabled` boolean flag in the `configuration` hash to disable the calendar bars. This is useful to display the regular pages of the collection whithout any fitering nor Calendar UI.

==- Calendar Methods

:::
- `@calendar.url_at(time_with_zone, **options)`
  - Returns a URL complete with all parameters for the pages in each filter bar that includes the given time. For example:
    `@calendar.url_at(Time.zone.now)` generates the filter bar URLs pointing to today.
  - If `time` is outside the pagination range it raises a `Pagy::RangeError`, however you can pass the `fit_time: true` option to avoid the error and get the url to the page closest to the passed time argument (first or last page).
:::

:::
- `@calendar.showtime`
  - Displays the time of the smallest time unit currently visible on the calendar.
:::

==- Unit Options

- `order: :desc`
  - Sets the order of the unit, either `:asc` or `:desc`. Make sure to order your collection accordingly.
- `format: '<strftime>'`
  - Change the label format for the unit links.

==- Offset configuration

This is the optional configuration for the core `:offset` paginator. If omitted a default one will be created. It is always used, regardless of the `:disabled` flag value.

It is not subject to the restrictions mentioned in the [Calendar configuration](#calendar-configuration).

==- Localization

Pagy provides the calendar localization only for `en` locales. For non-en locales pagy requires the `rails-i18n` to be installed.

Pass the locales that your app uses to the method `localize_with_rails_i18n_gem` in the [pagy.rb initializer](../../resources/initializer/):

```ruby
Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)
```

==- Caveats

!!!warning Calendar pages with no records are visible and accessible.

You may want to display a message when `@records.empty?`.
!!!

===
