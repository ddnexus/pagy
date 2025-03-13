---
label: input_nav_js
icon: code
order: 150
image: ""
categories:
  - Methods
  - Navs
  - Tags
---

#

## :icon-code: inout_nav_js

---

`input_nav_js` combines navigation and pagination info in a single compact element.

It is the fastest and lightest navigator, recommended when you care about efficiency and server load (
see [Maximizing Performance](../../guides/how-to#maximize-performance)) still needing UI.

![input_nav_js (:bootstrap style)](/assets/images/bootstrap_combo_nav_js.png)

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](../../sandbox/playground#3-demo-app)

!!!warning It works with all paginators but `:keyset`
!!!

```erb
<%== @pagy.input_nav_js(**options) %>  <%# default pagy style %>
<%== @pagy.input_nav_js(:bootstrap, **options) %>
<%== @pagy.input_nav_js(:bulma, **options) %>
```
Try this method in the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.input_nav_js
<nav class="pagy input-nav-js" aria-label="Pages" data-pagy="WyJjaiIsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><a href="/path?example=123&page=2" aria-label="Previous">&lt;</a><label>Page <input name="page" type="number" min="1" max="50" value="3" aria-current="page" style="text-align: center; width: 3rem; padding: 0;"><a style="display: none;">#</a> of 50</label><a href="/path?example=123&page=4" aria-label="Next">&gt;</a></nav>
=> nil

>> puts @pagy.input_nav_js(:bulma, id: 'combo-nav', aria_label: 'My Pages')
<nav id="combo-nav" class="pagy-bulma input-nav-js pagination is-centered" aria-label="My Pages" data-pagy="WyJjaiIsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><a href="/path?example=123&page=2" class="pagination-previous" aria-label="Previous">&lt;</a><a href="/path?example=123&page=4" class="pagination-next" aria-label="Next">&gt;</a><ul class="pagination-list"><li class="pagination-link"><label>Page <input name="page" type="number" min="1" max="50" value="3" aria-current="page"style="text-align: center; width: 3rem; height: 1.7rem; margin:0 0.3rem; border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; background-color: #485fc7;"><a style="display: none;">#</a> of 50</label></li></ul></nav>
=> nil
```   
==- Caveats

!!!danger Overriding `*_js*` helpers is not recommended

The `*_js*` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile
and might break in a next release.
!!!

==- Styles

See [Common Nav Styles](../methods#common-nav-styles)

==- Options

See [Common Nav Options](../methods#common-nav-options) and [Common URL Options](../paginators#common-url-options)
===
