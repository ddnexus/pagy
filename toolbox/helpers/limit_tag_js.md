#

## :icon-code-square:&nbsp;&nbsp;limit_tag_js&nbsp;&nbsp;[!button variant="info" icon="alert" size="s" corners="pill" text="JavaScript Setup Required!"](/resources/javascript)

---

:::raised
![](/assets/images/pagy-limit_tag_js.png){width=202}
:::
<br/>

:::content-center
[!button corners="pill" variant="info" icon="play-24" text="Check it out with `bundle exec pagy demo`"](/sandbox/playground/#demo)
:::

The `limit_tag_js` allows the user to select any arbitrary limit per page, up to the `:max_limit` option. It raises an `OptionError` exception if the `:max_limit` is not truthy.

!!!warning It works with all paginators but `:keyset`
!!!

=== :icon-tools:&nbsp; Usage

```erb
<%== @pagy.limit_tag_js %>
```

!!!success Pagy requests the _right_ page number
After selecting a new limit, pagy reloads the page that roughly contains the same items shown before the reload.
!!!

==- :icon-pin:&nbsp; Examples

```ruby Console
require 'pagy/console'
=> true

>> puts @pagy.limit_tag_js(max_limit: 100)
<span class="pagy limit-tag-js" data-pagy="WyJzaiIsNDEsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><label>Show <input name="limit" type="number" min="1" max="" value="20" style="padding: 0; text-align: center; width: 3rem;"><a style="display: none;">#</a> items per page</label></span>
=> nil

>> puts @pagy.limit_tag_js(max_limit: 100, id: 'my-elector', item_name: 'Products')
<span id="my-elector" class="pagy limit-tag-js" data-pagy="WyJzaiIsNDEsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><label>Show <input name="limit" type="number" min="1" max="" value="20" style="padding: 0; text-align: center; width: 3rem;"><a style="display: none;">#</a> Products per page</label></span>
=> nil
```

==- :icon-sliders:&nbsp; Options

`absolute: true`
: Makes the URL absolute.

`path: '/my_path'`
: Overrides the request path in pagination URLs. Use the path only (not the absolute URL). _(see [Override the request path](/guides/how-to#paginate-multiple-independent-collections))_

`fragment: '...'`
: URL fragment string.

`querify: tweak`
: Set it to a `Lambda` to directly edit the passed string-keyed params hash itself. Its result is ignored.
  ```ruby
  tweak = ->(q) { q.except!('not_useful').merge!('custom' => 'useful') }
  ```

==- :icon-alert:&nbsp; Caveats

!!!danger Overriding `*_js` helpers is not recommended
The `*_js` helpers are tightly coupled with the JavaScript code, so any partial overriding on one side would be quite fragile and might break in future releases.
!!!
===
