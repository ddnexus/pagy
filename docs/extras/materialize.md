---
title: Materialize
---
# Materialize Extra

This extra adds nav helper and templates for Materialize CSS framework [pagination component](https://materializecss.com/pagination.html).

## Synopsys

See [extras](../extras.md) for general usage info.

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_materialize(@pagy) %>
```

## Files

This extra is composed of 1 file:

- [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb)

## Methods

This extra adds one nav helpers to the `Pagy::Frontend` module. You can customize it by overriding it directly in your own view helper.

### pagy_nav_materialize(pagy)

This method is the same as the `pagy_nav`, but customized for Materialize.

## Templates

There is currently no template for Materialize. Please, create a Pull Request or an Issue requesting that.
