---
title: Pagy::Calendar
---
# Pagy::Calendar

This is a `Pagy` subclass (see [source](https://github.com/ddnexus/pagy/blob/master/lib/pagy/calendar.rb)) that paginates the collection by calendar units (year, month, week or day) instead of the usual number of `:items`. 

**Notice**: This class provides support for the [calendar extra](../extras/calendar.md). The class API is documented here, however you should not need to use this class directly because it is required and used internally by the extra.

**WARNING**: _This class has 100% of test coverage, however it's very new and its API could still change, so consider it as a version 0.x. Please, check the [Changelog](https://github.com/ddnexus/pagy/blob/master/CHANGELOG.md) for breaking changes before upgrading Pagy for minor version bumps. Patch versions are safe to upgrade without checking. (This warning will be removed as soon as the API will become stable.)_

## Overview

`Pagy::Calendar` splits the collection into pages of equal time unit, so if you choose `:year` as the unit, you will have one page per each different `:year` and each page will contain all the records that fall into the specific page year. You can also paginate by `:month` or `:week` or `:day`. 

Each page is also conveniently labeled in the navigation bar with the specific `Time` period it refers to.

**IMPORTANT**: This class respects the natural calendar units, not the duration of a unit. If you paginate by `:year`, each page will be a calendar year starting from the 1st of January and lasting one year, not a year starting and ending at two arbitrary dates one year apart. All the other units follow the same principle. Units with no records are displayed as empty pages.

**Notice**: This class uses only the ruby `Time` class for all its time calculations for great performance without dependencies.

## Variables

Being a subclass of `Pagy`, `Pagy::Calendar` shares most of its superclass infrastructure and variables, however it uses a completely different way to paginate, hence it has a different set of core variables.

The following variables are specific of `Pagy::Calendar`.

| Variable        | Description                                                                                                                                              | Default      |
|:----------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------|
| `:local_minmax` | Required 2 items Array that you must set to the minimum and maximum `Time` from the collection. You must also convert it to the local time of your user. | `[]`         |
| `:unit`         | Time unit for the pagination. It can be`:year`, `:month`, `:week` or `:day`                                                                              | `:month`     |
| `:week_offset`  | Day offset from Sunday (0: Sunday; 1: Monday;... 6: Saturday) used to adjust the starting day of the week                                                | `0`          |
| `:order`        | Order of pagination: it can be`:asc` or `:desc`                                                                                                          | `:asc`       |
| `:year_format`  | String containing the `strftime` format for the `:year` time units labels                                                                                | `'%Y'`       |
| `:month_format` | String containing the `strftime` format for the `:month` time units labels                                                                               | `'%Y-%m'`    |
| `:week_format`  | String containing the `strftime` format for the `:week` time units labels                                                                                | `'%Y-%W'`    |
| `:day_format`   | String containing the `strftime` format for the `:day` time units labels                                                                                 | `'%Y-%m-%d'` |

**WARNING** You should always convert the `:local_minmax` times to be local time of your user. In order to prevent mistakes, Pagy will raise an exception if you pass UTC times.

## Attribute Readers

`Pagy::Calendar` calculates a few specific `Time` variables and exposes them with other variables accessors with attribute readers:

| Reader        | Description                                                                                                  |
|:--------------|:-------------------------------------------------------------------------------------------------------------|
| `utc_from`    | The `UTC Time` of the start of the current page (use it to select the records with time `>= @pagy.utc_from`) |
| `utc_to`      | The `UTC Time` of the end of the current page (use it to select the records with time `< @pagy.utc_to`)      |
| `unit`        | The `:unit` variable.                                                                                        |
| `week_offset` | The `:week_offset` variable.                                                                                 |
| `order`       | The `:order` variable.                                                                                       |
   
## Attribute Accessors

| Accessor | Description                                                                                                           |
|:---------|:----------------------------------------------------------------------------------------------------------------------|
| `count`  | The collection `:count` variable. Pass it as a variable or assign it with the accessor if you need it                 |
| `in`     | The number of the retrieved items `:in` the page. Pass it as a variable or assign it with the accessor if you need it |

## Caveats

Being a subclass of `Pagy` this class inherit also its default variables and accessors, however it has no concept about the following variables that either make no sense in calendar pagination or are unknown to the `Pagy::Calendar` instance.

- Make no sense:
  - `:items`
  - `:offset`
  - `:outset`
  - `from`
  - `to` 
  
- Unknown (but you can pass them as variables or set them with their accessors if you need it):
  - `:count`
  - `in`
  
### Unsupported
   
Here is the list of what makes no sense or it is not supported in calendar pagination:

- `pagy_info` and `*_nav_js` helpers
- `gearbox` extra
- `items` extra   
- `arel` extra
- `array`, `elasticsearch_rails`, `searchkick`, `meilisearch` extras, however you can still calendar-paginate that collections by following the logic explained in the [calendar extra](../extras/calendar.md)

## Methods

### label(format = nil)

This method generates a label for the page with the specific `Time` period it refers to. It accepts an optional `strftime` format for customization.
  
### label_for(page, format = nil)

This method takes a page num (`Integer` or `String`) and generates a label for the page with the specific `Time` period it refers to. It accepts an optional `strftime` format for customization.
