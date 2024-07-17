---
title: Limit
categories:
  - Feature
  - Extra
---

# Limit Extra

Allow the client to request a custom `limit` per page with an optional selector UI. It is useful with APIs or
user-customizable UIs.

!!!success Try it now!

Run the interactive demo from your terminal:

```sh
pagy demo
# or: bundle exec pagy demo
```
...and point your browser at http://0.0.0.0:8000

!!!

It works also with the [countless](countless.md), [searchkick](searchkick.md), [elasticsearch_rails](elasticsearch_rails.md) 
and [meilisearch](meilisearch.md) extras, and with the [Pagy::Keyset Api](/docs/api/keyset.md) pagination.

## Synopsis

### Default usage

```ruby pagy.rb (initializer)
require 'pagy/extras/limit' # works without further configuration
```

```ruby Controller
# enabled by default
@pagy, @records = pagy(collection)
# you can disable it explicitly for specific requests
@pagy, @records = pagy(collection, limit_extra: false)
```

### Custom usage

```ruby pagy.rb (initializer)
# optionally disable it by default
Pagy::DEFAULT[:limit_extra] = false # default true
# customize the defaults if you need to
Pagy::DEFAULT[:limit_param] = :custom_param # default :limit
Pagy::DEFAULT[:max_limit]   = 200 # default 100
```

```ruby Controller
# disabled by default by the above Pagy::DEFAULT[:limit_extras] = false
@pagy, @records = pagy(collection)
# explicitly enable it for specific requests
@pagy, @records = pagy(collection, limit_extra: true)
```

See [Javascript](/docs/api/javascript.md) (only if you use the `pagy_limit_selector_js` UI)

## Variables

| Variable       | Description                                                          | Default  |
|:---------------|:---------------------------------------------------------------------|:---------|
| `:limit_extra` | Enable or disable the feature                                        | `true`   |
| `:limit_param` | The name of the limit param used in the url.                         | `:limit` |
| `:max_limit`   | The max limit allowed to be requested. Set it to `nil` for no limit. | `100`    |

You can use the `:limit_extra` variable to opt-out of the feature even when the extra is required.

This extra uses the `:limit_param` variable to determine the param it should get the `:limit` from.

The `:max_limit` is used to cap the `:limit` to that max. It is set to `100` by default. Set it to `nil` for no limit.

You may want to customize the variables. Depending on the scope of the customization, you have a couple of options:

As a global default:

```ruby pagy.rb (initializer)
Pagy::DEFAULT[:limit_param] = :custom_param
Pagy::DEFAULT[:max_limit]   = 50
```

For a single instance (overriding the global default):

```ruby Controller
pagy(collection, limit_param: :custom_param, max_limit: 50)
Pagy.new(count: 100, limit_param: :custom_param, max_limit: 50)
```

!!!info Override 'limit' in Params
You can override the limit that the client sends with the params by passing the `:limit` explicitly. For example:

```ruby
# this will ignore the params[:limit] (or any custom :my_limit)
# from the client for this instance, and override limit
pagy(scope, limit: 30)
```

!!!

## Methods

The `limit` extra adds the `pagy_limit_selector_js` helper to the `Pagy::Frontend` module.

==- `pagy_limit_selector_js(pagy, **vars)`

This helper provides a limit selector UI, which allows the user to select any arbitrary limit per page (below
the `:max_limit` number) in a numeric input field. It looks like:

<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> items per
page</span>

It returns an empty string if the `:limit_extra` is `false`.

The method accepts also a few optional keyword arguments variables:

- `:id` which adds the `id` HTML attribute to the `nav` tag
- `:item_name` an already pluralized string that will be used in place of the default `item/items`

```erb some_view.html.erb
<%== pagy_limit_selector_js(@pagy, item_name: 'Product'.pluralize(@pagy.count)) %>
```
!!!

<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> Products per
page</span>

_(see [How to customize the item name](/docs/how-to.md#customize-the-item-name))_

When the limit is changed with the selector, pagy will reload the pagination UI using the selected limit. It will
also request the _right_ page number calculated in order to contain the first item of the previously displayed page. That way the
new displayed page will roughly show the same items in the collection before the change.

This method can take an extra `id` argument, which is used as the `id` attribute of the wrapper `span` tag.

===
