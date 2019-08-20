---
title: Semantic
---
# Semantic UI Extra

This extra adds 3 nav helpers for Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html#pagination).

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/semantic'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_semantic_nav(@pagy) %>
<%== pagy_semantic_nav_js(@pagy) %>
<%== pagy_semantic_combo_nav_js(@pagy) %>
```

## Files

- [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

### pagy_semantic_nav(pagy)

This method is the same as the `pagy_nav`, but customized for Semantic UI.

### pagy_semantic_nav_js(pagy, ...)

This method is the same as the `pagy_nav_js`, but customized for the Semantic UI framework.

See more details in the [javascript navs](navs.md#javascript-navs) documentation.

### pagy_semantic_combo_nav_js(pagy, ...)

This method is the same as the `pagy_combo_nav_js`, but customized for the Semantic UI framework.

See more details in the [compact_navs_js](navs.md#javascript-combo-navs) documentation.
