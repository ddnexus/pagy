---
title: Gearbox
---
# Gearbox Extra

This extra allows your app to automatically change the number of items depending on the page number. Instead of generating all the pages with a fixed number of items, the app can serve pages with an increasing number of items in order to speed things up for wild-browsing and improving the user experience.

You can set this up by simply setting the `:gearbox_items` variable to an array of integers. For example, you would set the  `gearbox_items` to `[10, 20, 40, 80]` to have page `1` with `10` items, page `2` with `20`, page `3` with `40` and all the other pages with `80` items.

The content of the array is not restricted neither in length nor in direction: you can pass any arbitrary sequence of integer you like.

Even after requiring this extra, the regular fixed pagination is still supported: you have just to disable `gearbox` with `gearbox_extra: false` when you still need the fixed pagination.

You can also use it in presence of the the [items](items.md) extra following a simple logic. The `gearbox` extra automatically handles the items per page, while the `items` extra allows the user to explicitly request a specific number of items. That's why the `items`  extra will take priority over the `gearbox` extra if both extras are enabled. If you want to use the `gearbox` in a some instance, you can temporarily set `enable_items_extra: false` and the `gearbox`  will be used instead. That is a common scenario when you use the `items` extra in an API controller, while you want to use the `gearbox` in an infinite scroll pagination in another controller.

## Synopsis

See [extras](../extras.md) for general usage info.

```ruby
# pagy.rb initializer
require 'pagy/extras/gearbox'

# optional: set a different default in the pagy.rb initializer
# Pagy::VARS[:gearbox_extra] = false   # will make it opt-in only
# Pagy::VARS[:gearbox_items] = [15, 30, 60, 100]   # default
Pagy::Vars[:gearbox_items] = [10, 20, 50]   # your own default

# controller action
# or pass the :gearbox_items variable to a constructor to have it only for that instance
@pagy, @records = pagy(Product.all, gearbox_items: [30, 60, 100], ...)

# You can still use fixed pagination even after requiring the extra
@pagy, @records = pagy(Product.all, items: 30, gearbox_extra: false)

# If you use also the items extra it must be disabled in the instance that use the gearbox
@pagy, @records = pagy(Product.all, gearbox_items: [30, 60, 100], enable_items_extra: false)
```

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

The main differences are that the pagy implementation is not tied to `ActiveRecord` so it works in any environment, and that it's many many many times faster!
