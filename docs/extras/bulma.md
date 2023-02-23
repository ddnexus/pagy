---
title: Bulma
categories:
- Frontend
- Extra
image: none
---

# Bulma Extra

Add nav helpers and templates for the Bulma CSS [pagination component](https://bulma.io/documentation/components/pagination).

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/bulma'
```
|||

||| View (helpers)
```erb
<%== pagy_bulma_nav(@pagy, ...) %>
<%== pagy_bulma_nav_js(@pagy, ...) %>
<%== pagy_bulma_combo_nav_js(@pagy, ...) %>
```
|||

||| View (template)
```erb
<%== render partial: 'pagy/bulma_nav', locals: {pagy: @pagy} %>
```
|||

See [Javascript](/docs/api/javascript.md) if you use `pagy_bulma_nav_js` or `pagy_bulma_combo_nav_js`.

## Files

- [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb)
- [bulma_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.erb) (optional template)
- [bulma_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.haml) (optional template)
- [bulma_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.slim)  (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. 

!!!info Overriding Helpers
You can customize them by overriding in your own view helper(s).
!!!

=== `pagy_bulma_nav(pagy)`

![bulma_nav - medium view size](/docs/assets/images/bulma_nav_medium.png)

This method is the same as the `pagy_nav`, but customized for Bulma.

See the [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy-nav-pagy) documentation.

The `bulma_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [How to use templates](/docs/how-to.md#use-templates).

=== `pagy_bulma_nav_js(pagy, ...)`

![Warning: Bootstrap style shown above as a representative example - the responsive `pagy_bulma_nav_js` looks like the `pagy_bulma_nav` helper.](/docs/assets/images/bootstrap_nav_js.png)

It's rendered on the client, with optional responsiveness. See the [Javascript Navs](/docs/api/javascript/navs.md) documentation for more information.

=== `pagy_bulma_combo_nav_js(pagy, ...)`

![bulma_combo_nav_js](/docs/assets/images/bulma_combo_nav_js.png)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.

===
