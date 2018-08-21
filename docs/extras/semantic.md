---
title: Semantic UI
---
# Semantic UI Extra

This extra adds nav helper and templates for Semantic UI CSS [pagination component](https://semantic-ui.com/collections/menu.html).

## Synopsys

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/semantic'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_semantic(@pagy) %>
<%== pagy_nav_responsive_semantic(@pagy) %>
<%== pagy_nav_compact_semantic(@pagy) %>
```

## Files

This extra is composed of 1 file:

- [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_nav_semantic(pagy)

This method is the same as the `pagy_nav`, but customized for Semantic UI.

### pagy_nav_compact_semantic(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for the Bootstrap framework.

See more details in the [compact navs](navs.md#compact-navs) documentation.

### pagy_nav_responsive_semantic(pagy, ...)

This method is the same as the `pagy_nav_responsive`, but customized for the Bootstrap framework.

See more details in the [responsive navs](navs.md#responsive-navs) documentation.

## Templates

There is currently no template for Semantic UI. Please, create a Pull Request or an Issue requesting that.
