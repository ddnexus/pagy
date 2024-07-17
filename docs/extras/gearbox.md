---
title: Gearbox
categories:
- Feature
- Extra
---

# Gearbox Extra

Automatically change the `limit` depending on the page number.

Instead of generating all the pages with a fixed limit, the app can serve pages with an increasing number of records in
order to speed things up for wild-browsing and improving the user experience.

You can set this up by simply setting the `:gearbox_limit` variable to an array of integers. For example, you would set
the  `gearbox_limit` to `[10, 20, 40, 80]` to get page `1` with `limit: 10`, page `2` with `limit: 20`, page `3` with `limit: 40` and all the
other pages with `limit: 80`.

The content of the array is not restricted neither in length nor in direction: you can pass any arbitrary sequence of integer you
like, although it makes more sense to have an increasing progression of records.

### Interaction with other extras

Even after requiring this extra, the regular fixed pagination is still supported: you have just to temporarily disable `gearbox`
with `gearbox_extra: false` in the instances that need the fixed pagination.

You can also use it in presence of the [limit extra](limit.md) if you follow a simple logic. The `gearbox` extra automatically
handles the `:limit` for each page, while the [limit extra](limit.md) allows the client to explicitly request a specific 
`limit` for the pages. 
That's why the [limit extra](limit.md) takes priority over the `gearbox` extra if both are enabled.

If you want to use the `gearbox` in some instances, you can temporarily set `limit_extra: false` and the `gearbox`  will be used
instead. That is a common scenario when you use the [limit extra](limit.md) in an API controller, while you want to use the `gearbox` in an
infinite scroll pagination in another controller.

#### Caveats

- This extra cannot be used with `Pagy::Calendar::*` objects, which are paginated by period.
- The search extras (`elasticserch_rails`, `meilisearch` and `searchkick`) are based on storages with built-in linear pagination,
  which is inconsistent with the `gearbox`.

## Synopsis

```ruby pagy.rb (initializer)
require 'pagy/extras/gearbox'

# optional: set a different default in the pagy.rb initializer
# Pagy::DEFAULT[:gearbox_extra] = false   # will make it opt-in only
# Pagy::DEFAULT[:gearbox_limit] = [15, 30, 60, 100]   # default
Pagy::DEFAULT[:gearbox_limit] = [10, 20, 50]   # your own default
```

```ruby Controller (action)
# Optionally override the :gearbox_limit variable to a constructor to have it only for that instance
@pagy, @records = pagy(collection, gearbox_limit: [30, 60, 100], **vars)

# You can still use instances with fixed pagination even after requiring the extra
# use the default Pagy::DEFAULT[:limit]
@pagy, @records = pagy(collection, gearbox_extra: false)
# use the passed limit: 30
@pagy, @records = pagy(collection, gearbox_extra: false, limit: 30)

# If you use also the limit extra it must be disabled in the instance that use the gearbox
# use the default Pagy::DEFAULT[:gearbox_limit]
@pagy, @records = pagy(collection, limit_extra: false)
# use the passed gearbox_limit: [30, 60, 100]
@pagy, @records = pagy(collection, limit_extra: false, gearbox_limit: [30, 60, 100])
```

## Variables

| Variable         | Description                   | Default             |
|:-----------------|:------------------------------|:--------------------|
| `:gearbox_extra` | enable or disable the feature | `true`              |
| `:gearbox_limit` | array of positive integers    | `[15, 30, 60, 100]` |

## Methods

The `gearbox` extra overrides the `setup_limit_var` and the `setup_pages_vars` methods in the `Pagy` class. You don't have to use
them directly.

## Credits

The idea behind this extra comes from the [Geared Pagination](https://github.com/basecamp/geared_pagination).

The main differences are that Pagy is not tied to `ActiveRecord` so it works in any environment... many many many times faster!
