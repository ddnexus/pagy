---
title: Pagy::Calendar
---
# Pagy::Calendar::*

This is a `Pagy` subclass (see [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/calendar.rb)) that paginates the collection by calendar units (year, month, week or day) instead of the usual number of `:items`. 

**Notice**: This classes provide support for the [calendar extra](../extras/calendar.md) and are meant to be used with standard, non-calendar Pagy classes and never alone. The class API is documented here, however you should not need to use this class directly because it is required and used internally by the extra.

**WARNING**: _This class has 100% of test coverage, however it's very new and its API could still change, so consider it as a version 0.x. Please, check the [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md) for breaking changes before upgrading Pagy for minor version bumps. Patch versions are safe to upgrade without checking. (This warning will be removed as soon as the API will become stable.)_

## Overview

The pagy `Pagy::Calendar::*` instances split the collection into pages of equal time unit, so with `Pagy::Calendar::Year`, you will have one page per each different calendar year and each page can be filtered to contain all the records that fall into the specific page/year. You can also paginate with `Pagy::Calendar::Month` or `Pagy::Calendar::Week` or `Pagy::Calendar::Day`. 

Each page is also conveniently labeled in the navigation bar with the specific `Time` period it refers to.

**IMPORTANT**: This classes respects the natural calendar units, not the duration of a unit. If you paginate by year, each page will be a calendar year starting January 1st and ending the December 31st, not a year starting and ending at two arbitrary dates one year apart. All the other units follow the same principle. Units with no records are displayed as empty pages.
  
### Time objects

This class uses only the ruby `Time` class for all its time calculations for great performance without dependencies. 
              
It requires an initializing `:minmax` variable expressed in the user local time. Everything inside the class works in local time, explicitly converting only the `utc_from` and `utc_to` objects to UTC.

## Variables

Being a subclass of `Pagy`, `Pagy::Calendar::*` classes share most of their superclass infrastructure and variables, however they use a completely different way to paginate, hence they have a different set of core variables.

The following variables are specific of `Pagy::Calendar`.

| Variable        | Description                                                                                                                                           | Default      |
|:----------------|:------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------|
| `:minmax`       | Required two items Array that you must set to the minimum and maximum LOCAL `Time` from the collection.                                               | `nil`        |
| `:year_format`  | String containing the `strftime` format for the `:year` time units labels                                                                             | `'%Y'`       |
| `:month_format` | String containing the `strftime` format for the `:month` time units labels                                                                            | `'%Y-%m'`    |
| `:week_format`  | String containing the `strftime` format for the `:week` time units labels                                                                             | `'%Y-%W'`    |
| `:day_format`   | String containing the `strftime` format for the `:day` time units labels                                                                              | `'%Y-%m-%d'` |
| `:week_offset`  | Day offset from Sunday (0: Sunday; 1: Monday;... 6: Saturday) used to adjust the starting day of the week (only for `Page::Calendar::Week` instances) | `0`          |
| `:time_order`   | Order of pagination: it can be`:asc` or `:desc`                                                                                                       | `:asc`       |

**WARNING** You should always convert the `:minmax` times to be local time of your user. In order to prevent mistakes, Pagy will raise an exception if you pass UTC times.

## Attribute Readers

`Pagy::Calendar` calculates a few specific `Time` variables and exposes them and other variables accessors with attribute readers:

| Reader        | Description                                                                                            |
|:--------------|:-------------------------------------------------------------------------------------------------------|
| `utc_from`    | The `UTC Time` of the start of the current page (use it to select the records with time `>= utc_from`) |
| `utc_to`      | The `UTC Time` of the end of the current page (use it to select the records with time `< utc_to`)      |
| `week_offset` | The `:week_offset` variable (only for `Pagy::Calendar::Week` instances)                                |
| `time_order`  | The `:time_order` variable.                                                                            |

## Methods

### label(**opts)

This method generates a label for the page with the specific `Time` period it refers to (using the `:*_format` variable). It accepts an optional `format` keyword argument that can override the unit `:*_format` variable

### label_for(page, **opts)

This method takes a  <!-- items pagination -->
 page num (`Integer` or `String`) and generates a label for the page with the specific `Time` period it refers to (using the `:*_format` variable). It accepts an optional `format` keyword argument that can override the unit `:*_format` variable.
