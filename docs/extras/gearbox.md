---
title: Gearbox
categories:
- Feature
- Extra
---

# Gearbox Extra

Automatically change the number of items per page depending on the page number. 

Instead of generating all the pages with a fixed number of items, the app can serve pages with an increasing number of items in order to speed things up for wild-browsing and improving the user experience.

You can set this up by simply setting the `:gearbox_items` variable to an array of integers. For example, you would set the  `gearbox_items` to `[10, 20, 40, 80]` to have page `1` with `10` items, page `2` with `20`, page `3` with `40` and all the other pages with `80` items.

The content of the array is not restricted neither in length nor in direction: you can pass any arbitrary sequence of integer you like, although it makes more sense to have an increasing progression of items.    

### Interaction with other extras

Even after requiring this extra, the regular fixed pagination is still supported: you have just to temporarily disable `gearbox` with `gearbox_extra: false` in the instances that need the fixed pagination.

You can also use it in presence of the [items](items.md) extra if you follow a simple logic. The `gearbox` extra automatically handles the items per page, while the `items` extra allows the user to explicitly request a specific number of items. That's why the `items`  extra takes priority over the `gearbox` extra if both are enabled.

If you want to use the `gearbox` in some instances, you can temporarily set `items_extra: false` and the `gearbox`  will be used instead. That is a common scenario when you use the `items` extra in an API controller, while you want to use the `gearbox` in an infinite scroll pagination in another controller.

#### Caveats

- This extra cannot be used with `Pagy::Calendar::*` objects, which are paginated by period.
- The search extras (`elasticserch_rails`, `meilisearch` and `searchkick`) are based on storages with built-in linear pagination, which is inconsistent with the `gearbox`.

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/gearbox'

# optional: set a different default in the pagy.rb initializer
# Pagy::DEFAULT[:gearbox_extra] = false   # will make it opt-in only
# Pagy::DEFAULT[:gearbox_items] = [15, 30, 60, 100]   # default
Pagy::DEFAULT[:gearbox_items] = [10, 20, 50]   # your own default
```
|||

||| Controller (action)
```ruby
# Optionally override the :gearbox_items variable to a constructor to have it only for that instance
@pagy, @records = pagy(collection, gearbox_items: [30, 60, 100], ...)

# You can still use instances with fixed pagination even after requiring the extra
# use the default Pagy::DEFAULT[:items]
@pagy, @records = pagy(collection, gearbox_extra: false)
# use the passed items: 30
@pagy, @records = pagy(collection, gearbox_extra: false, items: 30)

# If you use also the items extra it must be disabled in the instance that use the gearbox
# use the default Pagy::DEFAULT[:gearbox_items]
@pagy, @records = pagy(collection, items_extra: false)
# use the passed gearbox_items: [30, 60, 100]
@pagy, @records = pagy(collection, items_extra: false, gearbox_items: [30, 60, 100])
```
|||

## Files

- [gearbox.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/gearbox.rb)

## Variables

| Variable         | Description                   | Default             |
| :--------------- | :---------------------------- | :------------------ |
| `:gearbox_extra` | enable or disable the feature | `true`              |
| `:gearbox_items` | array of positive integers    | `[15, 30, 60, 100]` |

## Methods

The `gearbox` extra overrides the `setup_items_var` and the `setup_pages_vars` methods in the `Pagy` class. You don't have to use them directly.

## Credits

The idea behind this extra comes from the [Geared Pagination](https://github.com/basecamp/geared_pagination).

The main differences are:

1. Pagy is not tied to `ActiveRecord` so it works in any environment
2. The [pagy-cursor](https://github.com/Uysim/pagy-cursor) pagination is a pagy-extra implemented in its own gem
3. Pagy is many many many times faster!
