---
title: Semantic UI
---
# Semantic UI Extra

This extra adds nav helper and templates for Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html#pagination).

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
<%== pagy_semantic_compact_nav_js(@pagy) %>
<%== pagy_semantic_nav_js(@pagy) %>
```

## Files

- [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_semantic_nav(pagy)

This method is the same as the `pagy_nav`/`pagy_plain_nav`, but customized for Semantic UI.

### pagy_semantic_compact_nav_js(pagy, ...)

This method is the same as the `pagy_plain_compact_nav_js`, but customized for the Semantic UI framework.

See more details in the [compact_navs_js](plain.md#javascript-compact-navs)  documentation.

### pagy_semantic_nav_js(pagy, ...)

This method is the same as the `pagy_plain_nav_js`, but customized for the Semantic UI framework.

See more details in the [javascript navs](plain.md#javascript-navs) documentation.

## Templates

There is currently no template for Semantic UI. Please, create a Pull Request or an Issue requesting that.
