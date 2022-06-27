---
title: Semantic
category: Frontend Extras
---
# Semantic UI Extra

This extra adds 3 nav helpers for Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html#pagination).

## Synopsis

See [extras](/docs/extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/semantic'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_semantic_nav(@pagy, ...) %>
<%== pagy_semantic_nav_js(@pagy, ...) %>
<%== pagy_semantic_combo_nav_js(@pagy, ...) %>
```

## Files

- [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

### pagy_semantic_nav(pagy)

This method is the same as the `pagy_nav`, but customized for Semantic UI.

See the [pagy_nav(pagy, ...)](/docs/api/frontend.md#pagy_navpagy-) documentation.

### pagy_semantic_nav_js(pagy, ...)

See the [Javascript Navs](/docs/api/javascript/navs.md) documentation.

### pagy_semantic_combo_nav_js(pagy, ...)

See the [Javascript Combo Navs](/docs/api/javascript/combo-navs.md) documentation.
