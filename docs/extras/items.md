---
title: Items
---
# Items Extra

Allow the client to request a custom number of items per page with an optional selector UI. It is useful with APIs or higly user-customizable apps.

It works also with the [countless](countless.md), [searchkick](searchkick.md) and [elasticsearch_rails](elasticsearch_rails.md) extras.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/items'

Pagy::VARS[:items_param] = :custom_param       # default :items
Pagy::VARS[:max_items]   = 100                 # default
```

See [Javascript](../api/javascript.md) (only if you use the `pagy_items_selector_js` UI)

## Files

- [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb)

## Variables

| Variable       | Description                                                          | Default  |
|:---------------|:---------------------------------------------------------------------|:---------|
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

The `items` extra overrides a couple of builtin methods and adds a helper to the `Pagy::Frontend` module.

### pagy_get_vars(collection, vars)

This extra overrides the `pagy_get_vars` method of the `Pagy::Backend` module in order to set the `:items` variable, pulled from the request-params.

### pagy_countless_get_vars(collection, vars)

This extra overrides the `pagy_countless_get_vars` method of the `Pagy::Backend` module (added by the `countless` extra) in order to set the `:items` variable, pulled from the request-params.

### pagy_url_for(pagy, page, absolute: nil)

This extra overrides also the `pagy_url_for` method of the `Pagy::Frontend` module in order to add the `:items_param` param to the url of the links.

### pagy_items_selector_js(pagy, ...)

This helper provides an items selector UI, which allows the user to select any arbitrary number of items per page (below the `:max_items` number) in a numeric input field. It looks like:

<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> items per page</span>

The method accepts also a few optional keyword arguments:
- `:pagy_id` which adds the `id` HTML attributedto the `nav` tag
- `:item_name` an already pluralized string that will be used in place of the default `item/items`
- `:i18n_key` the key to lookup in a dictionary
- `:link_extra` which add a verbatim string to the `a` tag (e.g. `'data-remote="true"'`)

Notice the `:i18n_key` can be passed also to the constructor or be a less useful global variable (i.e. `VARS[:i18n_key]`

```erb
<%== pagy_items_selector_js(@pagy, item_name: 'Product'.pluralize(@pagy.count) %>
<%== pagy_items_selector_js(@pagy, i18n_key: 'activerecord.model.product' %>
```

<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> Products per page</span>

_(see [Customizing the item name](../how-to.md#customizing-the-item-name))_

When the items number is changed with the selector, pagy will reload the pagination UI using the selected items per page. It will also request the _right_ page number calculated in order to contain the first item of the previously displayed page. That way the new displayed page will roughly show the same items in the collection before the items change.

This method can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag. Since the internal automatic id generation is based on the code line where you use the helper, you _must_ pass an explicit id if you are going to use more than one `*_js` call in the same line for the same file.

**Notice**: passing an explicit id is also a bit faster than having pagy to generate one.

