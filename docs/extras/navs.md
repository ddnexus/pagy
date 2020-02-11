---
title: Navs
---
# Navs Extra

This extra adds a couple of javascript nav helpers to the `Pagy::Frontend` module: `pagy_combo_nav_js` and `pagy_nav_js`. These are the unstyled versions of the javascript-powered nav helpers.

Other extras (e.g. [bootstrap](bootstrap.md), [bulma](bulma.md), [foundation](foundation.md), [materialize](materialize.md), [semantic](semantic.md)) provide framework-styled versions of the same `nav` helpers, so you may not need this extra if you use one of the above framework-styled extra.

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/navs'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_js(@pagy) %>
<%== pagy_combo_nav_js(@pagy) %>
```

See [Javascript](../api/javascript.md).

## Files

- [navs.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/navs.rb)

## Methods

### pagy_nav_js(pagy, ...)

See the [Javascript Navs](../api/javascript.md#javascript-navs) documentation.

### pagy_combo_nav_js(pagy, ...)

See the [Javascript Combo Navs](../api/javascript.md#javascript-combo-navs) documentation.
