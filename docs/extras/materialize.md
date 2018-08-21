---
title: Materialize
---
# Materialize Extra

This extra adds nav helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html).

## Synopsys

See [extras](../extras.md) for general usage info.

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_materialize(@pagy) %>
<%== pagy_nav_responsive_materialize(@pagy) %>
<%== pagy_nav_compact_materialize(@pagy) %>
```

Configure [javascript](../extras.md#javascript) if you use `pagy_nav_responsive_materialize` or `pagy_nav_compact_materialize`.

## Files

This extra is composed of 1 file:

- [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_nav_materialize(pagy)

This method is the same as the `pagy_nav`, but customized for Materialize.

### pagy_nav_compact_materialize(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for the Materialize CSS framework.

Here is an example:

![pagy-compact-materialize](../assets/images/pagy-compact-materialize-g.png)

See more details in the [compact navs](navs.md#compact-navs) documentation.

### pagy_nav_responsive_materialize(pagy, ...)

This method is the same as the `pagy_nav_responsive`, but customized for the Materialize CSS framework.

See more details in the [responsive navs](navs.md#responsive-navs) documentation.

## Templates

There is currently no template for Materialize. Please, create a Pull Request or an Issue requesting it.
