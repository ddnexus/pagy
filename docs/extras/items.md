---
title: Items
categories:
- Feature
- Extras
---

# Items Extra

Allow the client to request a custom number of items per page with an optional selector UI. It is useful with APIs or user-customizable UIs.

It works also with the [countless](countless.md), [searchkick](searchkick.md), [elasticsearch_rails](elasticsearch_rails.md) and [meilisearch](/docs/extras/meilisearch.md) extras.

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/items' # works without further configuration
```
|||


||| Controller
```ruby
# you can disable it explicitly for specific requests
@pagy, @records = pagy(Product.all, items_extra: false)

# or see below:
```
|||


||| pagy.rb (initializer)
```ruby
# disable it by default (opt-in)
Pagy::DEFAULT[:items_extra] = false   # default true
# in this case you have to enable it explicitly when you want it
@pagy, @records = pagy(Product.all, items_extra: true)

# customize the defaults if you need to
Pagy::DEFAULT[:items_param] = :custom_param       # default :items
Pagy::DEFAULT[:max_items]   = 200                 # default 100
```
|||

See [Javascript](/docs/api/javascript.md) (only if you use the `pagy_items_selector_js` UI)

## Files

- [items.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/items.rb)

## Variables

| Variable       | Description                                                          | Default  |
| :------------- | :------------------------------------------------------------------- | :------- |
| `:items_extra` | enable or disable the feature                                        | `true`   |
| `:items_param` | the name of the items param used in the url.                         | `:items` |
| `:max_items`   | the max items allowed to be requested. Set it to `nil` for no limit. | `100`    |

You can use the `:items_extra` variable to opt-out of the feature even when the extra is required.

This extra uses the `:items_param` variable to determine the param it should get the number of `:items` from.

The `:max_items` is used to cap the number of items to that max. It is set to `100` by default. If you don't want to limit the max requested number of items per page, you can set it to `nil`.

You may want to customize the variables. Depending on the scope of the customization, you have a couple of options:

As a global default:

||| pagy.rb (initializer)

```ruby
Pagy::DEFAULT[:items_param] = :custom_param
Pagy::DEFAULT[:max_items]   = 50
```
|||

For a single instance (overriding the global default):

||| Controller

```ruby
pagy(scope, items_param: :custom_param, max_items: 50)
Pagy.new(count: 100, items_param: :custom_param, max_items: 50)
```
|||


!!!info Override 'items' in Params
You can override the items that the client sends with the params by passing the `:items` explicitly. For example:

```ruby
# this will ignore the params[:items] (or any custom :param_name)
# from the client for this instance, and serve 30 items
pagy(scope, items: 30)
```
!!!

## Methods

The `items` extra adds the `pagy_items_selector_js` helper to the `Pagy::Frontend` module.

==- `pagy_items_selector_js(pagy, ...)`

This helper provides an items selector UI, which allows the user to select any arbitrary number of items per page (below the `:max_items` number) in a numeric input field. It looks like:

<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> items per page</span>

It returns an empty string if the `:items_extra` is `false`.

The method accepts also a few optional keyword arguments:

- `:pagy_id` which adds the `id` HTML attribute to the `nav` tag
- `:item_name` an already pluralized string that will be used in place of the default `item/items`
- `:i18n_key` the key to lookup in a dictionary
- `:link_extra` which add a verbatim string to the `a` tag (e.g. `'data-remote="true"'`)


!!!info Info
The `:i18n_key` can be passed also to the constructor or be a less useful global variable (i.e. `Pagy::DEFAULT[:i18n_key]`

||| some_view.html.erb

```erb
<%== pagy_items_selector_js(@pagy, item_name: 'Product'.pluralize(@pagy.count) %>
<%== pagy_items_selector_js(@pagy, i18n_key: 'activerecord.model.product' %>
```
|||
!!!


<span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> Products per page</span>

_(see [How to customize the item name](/docs/how-to.md#customize-the-item-name))_

When the items number is changed with the selector, pagy will reload the pagination UI using the selected items per page. It will also request the _right_ page number calculated in order to contain the first item of the previously displayed page. That way the new displayed page will roughly show the same items in the collection before the items change.

This method can take an extra `id` argument, which is used to build the `id` attribute of the `nav` tag.

===
