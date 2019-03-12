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
<%== pagy_semantic_compact_nav(@pagy) %>
<%== pagy_semantic_responsive_nav(@pagy) %>
```

## Files

- [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_semantic_nav(pagy)

This method is the same as the `pagy_nav`/`pagy_plain_nav`, but customized for Semantic UI.

### pagy_semantic_compact_nav(pagy, ...)

This method is the same as the `pagy_plain_compact_nav`, but customized for the Semantic UI framework.

See more details in the [compact navs](plain.md#compact-navs) documentation.

### pagy_semantic_responsive_nav(pagy, ...)

This method is the same as the `pagy_plain_responsive_nav`, but customized for the Semantic UI framework.

See more details in the [responsive navs](plain.md#responsive-navs) documentation.

## Templates

There is currently no template for Semantic UI. Please, create a Pull Request or an Issue requesting that.
