---
title: Bulma
---
# Bulma Extra

This extra adds nav helper and templates for the Bulma CSS [pagination component](https://bulma.io/documentation/components/pagination).

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/bulma'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_bulma_nav(@pagy) %>
<%== pagy_bulma_responsive_nav(@pagy) %>
<%== pagy_bulma_compact_nav(@pagy) %>
```

or with a template:

```erb
<%== render 'pagy/nav_bulma', locals: {pagy: @pagy} %>
```

Configure [javascript](../extras.md#javascript) if you use `pagy_bulma_responsive_nav` or `pagy_bulma_compact_nav`.

## Files

This extra is composed of 4 files:

- [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb)
- [nav_bulma.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bulma.html.erb) (optional template)
- [nav_bulma.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bulma.html.haml) (optional template)
- [nav_bulma.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bulma.html.slim)  (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_bulma_nav(pagy)

This method is the same as the `pagy_nav`, but customized for Bulma.

The `nav_bulma.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

### pagy_bulma_compact_nav(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for the Bulma CSS framework.

Here is an example:

![pagy-compact-bulma](../assets/images/pagy-compact-bulma-g.png)

See more details in the [compact navs](navs.md#compact-navs) documentation.

### pagy_bulma_responsive_nav(pagy, ...)

This method is the same as the `pagy_nav_responsive`, but customized for the Bulma CSS framework.

See more details in the [responsive navs](navs.md#responsive-navs) documentation.

### Optional Template Files

See [Using Templates](../how-to.md#using-templates).
