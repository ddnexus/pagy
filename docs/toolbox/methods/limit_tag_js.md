---
label: limit_tag_js
icon: code-square
order: 130
image: ""
categories:
  - Methods
  - Tags
---

#

## :icon-code-square: limit_tag_js

---

![limit_tag_js](../../assets/images/limit_tag_js.png){width=202}

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#3-demo-app)

The `limit_tag_js` allows the user to select any arbitrary limit per page, up to the `:client_max_limit` option. It raises an `OptionError` exception if the `:client_max_limit` is not truthy.

!!!warning It works with all paginators but `:keyset`
!!!

```erb
<%== @pagy.limit_tag_js %>
```

Try this method in the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.limit_tag_js(client_max_limit: 100)
<span class="pagy limit-tag-js" data-pagy="WyJzaiIsNDEsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><label>Show <input name="limit" type="number" min="1" max="" value="20" style="padding: 0; text-align: center; width: 3rem;"><a style="display: none;">#</a> items per page</label></span>
=> nil

>> puts @pagy.limit_tag_js(client_max_limit: 100, id: 'my-elector', item_name: 'Products')
<span id="my-elector" class="pagy limit-tag-js" data-pagy="WyJzaiIsNDEsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><label>Show <input name="limit" type="number" min="1" max="" value="20" style="padding: 0; text-align: center; width: 3rem;"><a style="display: none;">#</a> Products per page</label></span>
=> nil
```

!!!success Pagy requests the _right_ page number

After selecting a new limit, pagy reloads the page that roughly contains the same items shown before the reload.
!!!

==- Caveats

!!!danger Overriding `*_js` helpers is not recommended

The `*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile
and might break in a next release.
!!!

==- Options

See [Common URL Options](../paginators#common-url-options)

===
