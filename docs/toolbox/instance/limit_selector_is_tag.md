---
title: limit_selector_js_tag
icon: code-square
order: 130
categories:
  - Methods
  - Tags
---


The `limit_selector_js_tag` allows the user to select any arbitrary limit per page, up-to the `:requestable_limit` option. It raises an `OptionError` exception if the `:requestable_limit` is not truthy.

```erb some_view.html.erb
<%== @pagy.limit_selector_js_tag %>
```

Try it with the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.limit_selector_js_tag(requestable_limit: 100)
<span class="pagy limit-selector-js" data-pagy="WyJzaiIsNDEsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><label>Show <input name="limit" type="number" min="1" max="" value="20" style="padding: 0; text-align: center; width: 3rem;"><a style="display: none;">#</a> items per page</label></span>
=> nil

>> puts @pagy.limit_selector_js_tag(requestable_limit: 100, id: 'my-elector', item_name: 'Products')
<span id="my-elector" class="pagy limit-selector-js" data-pagy="WyJzaiIsNDEsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><label>Show <input name="limit" type="number" min="1" max="" value="20" style="padding: 0; text-align: center; width: 3rem;"><a style="display: none;">#</a> Products per page</label></span>
=> nil
```

It looks like: <span>Show <input type="number" min="1" max="100" value="20" style="padding: 0; text-align: center; width: 3rem;"> Products per
page</span>

_(see [How to customize the item name](../../guides/how-to.md#customize-the-item-name))_


!!!success Pagy requests the _right_ page number

After selecting a new limit, pagy reloads the page that roughly contains the same items shown before the reload.
!!!

==- Options

See [Common URL Options](../instance.md#common-url-options)

===
