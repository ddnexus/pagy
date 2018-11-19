---
title: Items
---
# Items Extra

Allow the client to request a custom number of items per page with an optional selector UI. It is useful with APIs or higly user-customizable apps.

It works also with the [countless extra](countless.md).

## Synopsys

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/items'

Pagy::VARS[:items_param] = :custom_param       # default :items
Pagy::VARS[:max_items]   = 100                 # default
```

Configure [javascript](../extras.md#javascript) (only if you use the `pagy_items_selector` UI)

## Files

This extra is composed of the [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb) and may use the [pagy.js](https://github.com/ddnexus/pagy/blob/master/lib/javascripts/pagy.js) file.

## Variables

| Variable       | Description                                                          | Default  |
| -------------- | -------------------------------------------------------------------- | -------- |
| `:items_param` | the name of the items param used in the url.                         | `:items` |
| `:max_items`   | the max items allowed to be requested. Set it to `nil` for no limit. | `100`    |

This extra uses the `:items_param` variable to determine the param it should get the number of `:items` from.

The `:max_items` is used to cap the number of items to that max. It is set to `100` by default. If you don't want to limit the max requested number of items per page, you can set it to `nil`.

You may want to customize the variables. Depending on the scope of the customization, you have a couple of options:

As a global default:

```ruby
Pagy::VARS[:items_param] = :custom_param
Pagy::VARS[:max_items]   = 50
```

For a single instance (overriding the global default):

```ruby
pagy(scope, items_param: :custom_param, max_items: 50)
Pagy.new(count:100, items_param: :custom_param, max_items: 50)
```

**Notice**: you can override the items that the client sends with the params by passing the `:items` explicitly. For example:

```ruby
# this will ignore the params[:items] (or any custom :param_name)
# from the client for this instance, and serve 30 items
pagy(scope, items: 30)
```

## Methods

The `items` extra overrides a couple of builtin methods and adds a helper to the `Pagy::Frontend` module. All the overridden methods are alias-chained with `*_with_items` and `*_without_items`)

### pagy_get_vars(collection, vars)

This extra overrides the `pagy_get_vars` method of the `Pagy::Backend` module in order to set the `:items` variable, pulled from the request-params.

### pagy_countless_get_vars(collection, vars)

This extra overrides the `pagy_countless_get_vars` method of the `Pagy::Backend` module (added by the `countless` extra) in order to set the `:items` variable, pulled from the request-params.

### pagy_url_for(page, pagy)

This extra overrides also the `pagy_url_for` method of the `Pagy::Frontend` module in order to add the `:items_param` param to the url of the links.

### pagy_items_selector(pagy)

This helper provides an items selector UI, which allows the user to select any arbitrary number of items per page (below the `:max_items` number) in a numeric input field. It looks like:

<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> items per page</span>

You can change/translate its text by editing the `pagy.items` value in the [dictionaray files](https://github.com/ddnexus/pagy/blob/master/lib/locales).

When the items number is changed with the selector, pagy will reload the pagination UI using the selected items per page. It will also request the _right_ page number calculated in order to contain the first item of the previously displayed page. That way the new displayed page will roughly show the same items in the collection before the items change.
