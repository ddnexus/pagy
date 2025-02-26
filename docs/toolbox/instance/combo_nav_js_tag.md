---
title: combo_nav_js_tag
icon: code
order: 150
image: none
categories:
  - Methods
  - Navs
  - Tags
---

The `combo_nav_js_tag` offers a tag that combines navigation and pagination info in a single compact element.

It is the fastest and lightest navigator, recommended when you care about efficiency and server load (
see [Maximizing Performance](../../guides/how-to.md#maximize-performance)) still needing UI.

![combo_nav_js (:bootstrap style)](/assets/images/bootstrap_combo_nav_js.png)

[!button corners="pill" variant="success" text=":icon-play: Try it now!"](/docs/Practical%20Guide/playground.md#3-demo-app)


```erb Any View
<%== @pagy.combo_nav_js_tag(**options) %>
<%== @pagy.combo_nav_js_tag(:bootstrap, **options) %>
<%== @pagy.combo_nav_js_tag(:bulma, **options) %>
```
Try it with the [Pagy Console](../../sandbox/console.md):

```ruby
>> puts @pagy.combo_nav_js_tag
<nav class="pagy combo-nav-js" aria-label="Pages" data-pagy="WyJjaiIsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><a href="/path?example=123&page=2" aria-label="Previous">&lt;</a><label>Page <input name="page" type="number" min="1" max="50" value="3" aria-current="page" style="text-align: center; width: 3rem; padding: 0;"><a style="display: none;">#</a> of 50</label><a href="/path?example=123&page=4" aria-label="Next">&gt;</a></nav>
=> nil
>> puts @pagy.combo_nav_js_tag(:bulma, id: 'combo-nav', aria_label: 'My Pages')
<nav id="combo-nav" class="pagy-bulma combo-nav-js pagination is-centered" aria-label="My Pages" data-pagy="WyJjaiIsIi9wYXRoP2V4YW1wbGU9MTIzJnBhZ2U9UCAiXQ=="><a href="/path?example=123&page=2" class="pagination-previous" aria-label="Previous">&lt;</a><a href="/path?example=123&page=4" class="pagination-next" aria-label="Next">&gt;</a><ul class="pagination-list"><li class="pagination-link"><label>Page <input name="page" type="number" min="1" max="50" value="3" aria-current="page"style="text-align: center; width: 3rem; height: 1.7rem; margin:0 0.3rem; border: none; border-radius: 4px; padding: 0; font-size: 1.1rem; color: white; background-color: #485fc7;"><a style="display: none;">#</a> of 50</label></li></ul></nav>
=> nil
```   
==- Caveats

!!!danger Overriding `*_js` helpers is not recommended

The `pagy*_js` helpers are tightly coupled with the javascript code, so any partial overriding on one side, would be quite fragile
and might break in a next release.
!!!

==- Styles

- default
- `:boostrap`
  - Set `classes: 'pagination bootstrap class` to override the default `'pagination'` class.
- `:bulma`
  - Set `classes: 'pagination bulma class` to override the default `'pagination is-centered'` classes.

==- Options

See [Common Nav Options](../instance.md#common-nav-options) and [Common URL Options](../instance.md#common-url-options)
===
