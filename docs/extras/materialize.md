---
title: Materialize
---
# Materialize Extra

This extra adds nav helpers for the Materialize CSS [pagination component](https://materializecss.com/pagination.html).

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/materialize'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_materialize_nav(@pagy) %>
<%== pagy_materialize_nav_js(@pagy) %>
<%== pagy_materialize_compact_nav_js(@pagy) %>
```

Configure [javascript](../extras.md#javascript) if you use `pagy_materialize_nav_js` or `pagy_materialize_compact_nav_js`.

## Files

- [materialize.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/materialize.rb)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_materialize_nav(pagy)

This method is the same as the `pagy_nav`/`pagy_plain_nav`, but customized for Materialize.

### pagy_materialize_compact_nav_js(pagy, ...)

This method is the same as the `pagy_plain_compact_nav_js`, but customized for the Materialize CSS framework.

Here is an example:

![pagy-compact-materialize](../assets/images/pagy-compact-materialize-g.png)

See more details in the [compact_navs_js](plain.md#javascript-compact-navs)  documentation.

### pagy_materialize_nav_js(pagy, ...)

This method is the same as the `pagy_plain_nav_js`, but customized for the Materialize CSS framework.

See more details in the [javascript navs](plain.md#javascript-navs) documentation.

## Templates

There is currently no template for Materialize. Please, create a Pull Request or an Issue requesting it.
