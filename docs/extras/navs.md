---
title: Navs
categories:
- Frontend
- Extras
---
# Navs Extra

This extra adds a couple of javascript nav helpers to the `Pagy::Frontend` module: `pagy_combo_nav_js` and `pagy_nav_js`. These are the unstyled versions of the javascript-powered nav helpers.

Other extras (e.g. [bootstrap](bootstrap.md), [bulma](bulma.md), [foundation](foundation.md), [materialize](materialize.md), [semantic](semantic.md)) provide framework-styled versions of the same `nav` helpers, so you may not need this extra if you use one of the above framework-styled extra.

## Synopsis

||| pagy.rb (initializer)
```ruby
require 'pagy/extras/navs'
```
|||

||| View (helper)
```erb
<%== pagy_nav_js(@pagy, ...) %>
<%== pagy_combo_nav_js(@pagy, ...) %>
```
|||

||| View (template)
```erb
<%== render partial: 'pagy/nav', locals: {pagy: @pagy} %>
```
|||


See [Javascript](/docs/api/javascript.md).

## Files

- [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb)

## Methods

### pagy_nav_js(pagy, ...)

See the [Javascript Navs](/docs/api/javascript/navs.md) documentation.

### pagy_combo_nav_js(pagy, ...)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.
