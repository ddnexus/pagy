---
title: Pagy::Calendar
---
# Pagy::Calendar

This is a `Pagy` subclass (see [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/calendar.rb)) that provides pagination filtering by time (Year, Month, Week Day). 

**Notice**: The `Pagy::Calendar::*` classes provide support for the [calendar extra](../extras/calendar.md) and are meant to be used with standard, non-calendar Pagy classes and never alone (because they could generate a very high number of items per page). The class APIs are documented here, however you should not need to use them directly because they are required and used internally by the extra.

## Overview

The pagy `Pagy::Calendar::*` instances split a time period into pages of equal time unit. For example: with `Pagy::Calendar::Year` you will have one page per each different calendar year so each page can be filtered to contain all the records that fall into the specific page/year. The `Pagy::Calendar::Month`, `Pagy::Calendar::Week` and `Pagy::Calendar::Day` classes have the same functions for their respective time units. 

Each page is also conveniently labeled in the navigation bar with the specific `Time` period it refers to.

**IMPORTANT**: This classes respects the natural calendar units, not the duration of a unit. If you paginate by year, each page will be a calendar year starting January 1st and ending December 31st, not a period starting and ending at two arbitrary dates one year apart. All the classes follow the same principle. Time units with no records are displayed as empty pages.

## Variables

Being subclasses of `Pagy`, the `Pagy::Calendar::*` classes share most of their superclass infrastructure and variables, however they use a completely different way to paginate, hence they have a few extra core variables.

The following variables are specific to `Pagy::Calendar::*` instances: 

| Variable  | Description                                                                                    | Default |
|:----------|:-----------------------------------------------------------------------------------------------|:--------|
| `:period` | Required two items Array with the calendar starting and ending local `Time` objects            | `nil`   |
| `:order`  | Order of pagination: it can be`:asc` or `:desc`                                                | `:asc`  |
| `:format` | String containing the `strftime` format used for labelling (each subclass has its own default) |         |
| `:offset` | Day offset from Sunday (0: Sunday; 1: Monday;... 6: Saturday) (`Pagy::Calendar::Week` only)    | `0`     |

## DEFAULT variables

The calendar defaults are not part of the `Pagy::DEFAULT` variables. Each subclass has its own `Pagy::Calendar::*::DEFAULT` variable hash that you can set independently. See the [pagy.rb](https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb) configuration file for details. 

## Attribute Readers

| Reader   | Description                                                    |
|:---------|:---------------------------------------------------------------|
| `from`   | The local `Time` of the start of the current page              |
| `to`     | The local `Time` of the end of the current page                |
| `offset` | The `:offset` variable of the `Pagy::Calendar::Week` instances |
| `order`  | The `:order` variable                                          |

### About from and to objects

- The `from` is the beginning of the current time unit. Notice that for the first page it falls BEFORE the min time.
- The `to` is the beginning of the next time unit. Notice that for the last page it falls AFTER the max time. 

The cases for first and last pages have no effect when you use the `from`/`to` as a collection filter, since there are no records outside the `:period` of the collection.

### Time conversions

This classes use only the ruby `Time` class for all their time calculations for great performance without dependencies.

Since they are meant to be used in the UI, they have to do their internal calculation using the user/server local time in order to make sense for the UI. For that reason their input/output is always local time.

If you use `ActiveRecord`, your app should set the `Time.zone` for your user or your server. Then you can convert an UTC time from the storage to a local `Time` object for the calendar very easily with:

```ruby
utc_time_field.in_time_zone.to_time
```

You can also convert from local `Time` object to a UTC time with `local_time.utc`, however, when you use it as an argument in a scope, `ActiveRecord` converts it for you.

For general usage without `ActiveRecord` you can simply use the `Time` methods to convert `utc_time.getlocal(utc_offset)` and `local_time.utc`.

## Methods

### label(**opts)

This method uses the `:format` variable to generate the current page label with the specific `Time` period it refers to. It accepts an optional `format` keyword argument for overriding.

### label_for(page, **opts)

This method takes a page argument (`Integer` or `String`) and uses the `:format` variable to generate its label with the specific `Time` period it refers to. It accepts an optional `format` keyword argument for overriding.
