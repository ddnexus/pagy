---
title: Semantic UI
---
# Semantic UI Extra

This extra adds nav helper and templates for Semantic UI CSS framework [pagination component](https://semantic-ui.com/collections/menu.html).

## Synopsys

See [extras](../extras.md) for general usage info.

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_semantic(@pagy) %>
```

## Files

This extra is composed of 1 file:

- [semantic.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/semantic.rb)

## Methods

This extra adds one nav helpers to the `Pagy::Frontend` module. You can customize it by overriding it directly in your own view helper.

### pagy_nav_semantic(pagy)

This method is the same as the `pagy_nav`, but customized for Semantic UI.

## Templates

There is currently no template for Semantic UI. Please, create a Pull Request or an Issue requesting that.
