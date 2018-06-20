---
title: Items
---
# Items Extra

Allow the client to request a custom number of items per page with a ready to use selector UI. It is useful with APIs or higly user-customizable apps.

## Synopsys

See [extras](../extras.md) for general usage info.

In the Pagy initializer:

```ruby
require 'pagy/extra/items'

Pagy::VARS[:items_param] = :custom_param       # default :items
Pagy::VARS[:max_items]   = 100                 # default

# in rails apps: add the assets-path (only required if you use the pagy_items_selector helper)
Rails.application.config.assets.paths << Pagy.root.join('pagy', 'extras', 'javascripts')
```

In rails: add the javascript file to the application.js

```js
// only required if you use the pagy_items_selector helper
//= require pagy-items
```

In non-rails apps: ensure the `pagy/extras/javascripts/pagy-items.js` script gets served with the page.

Then you may want to use the `pagy_items_selector` helper in any view:

```erb
<%== pagy_items_selector(@pagy) %>
```

## Files

This extra is composed of 2 small files:

- [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb)
- [pagy-items.js](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/javascripts/pagy-items.js)

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

**Notice**: you can override items that the client send with the params by passing the `:items` explicitly. For example:

```ruby
# this will ignore the params[:item] (or any custom :param_name)
# from the client for this instance, and serve 30 items
pagy(scope, items: 30)
```

## Methods

The `items` extra overrides a couple of builtin methods and adds a helper to the `Pagy::Frontend` module.

### pagy_get_vars(collection, vars)

This extra overrides the `pagy_get_vars` method of the `Pagy::Backend` module in order to set the `:items` variable, pulled from the request-params. The built-in `pagy_get_vars` method is aliased as `built_in_pagy_get_vars` and is called internally and still available.

### pagy_url_for(page, pagy)

This extra overrides also the `pagy_url_for` method of the `Pagy::Frontend` module in order to add the `:items_param` param to the url of the links.

### pagy_items_selector(pagy)

This helper provides an items selector UI, which allows the user to select any arbitrary number of items per page below the `:max_items` number in a numeric input field. It looks like:

<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> items per page</span>

When the items number is changed with the selector, pagy will reload the pagination UI using the selected items per page. It will also request the _right_ page number calculated in order to contain the first item of the previously displayed page. That way the new displayed page will roughly show the same items in the collection.
