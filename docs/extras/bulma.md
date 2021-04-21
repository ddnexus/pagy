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
<%== pagy_bulma_nav(@pagy, ...) %>
<%== pagy_bulma_nav_js(@pagy, ...) %>
<%== pagy_bulma_combo_nav_js(@pagy, ...) %>
```

or with a template:

```erb
<%== render partial: 'pagy/bulma_nav', locals: {pagy: @pagy} %>
```

See [Javascript](../api/javascript.md) if you use `pagy_bulma_nav_js` or `pagy_bulma_combo_nav_js`.

## Files

- [bulma.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bulma.rb)
- [bulma_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.erb) (optional template)
- [bulma_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.haml) (optional template)
- [bulma_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/bulma_nav.html.slim)  (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

### pagy_bulma_nav(pagy)

This method is the same as the `pagy_nav`, but customized for Bulma.

See the [pagy_nav(pagy, ...)](../api/frontend.md#pagy_navpagy-) documentation.

The `bulma_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [Using Templates](../how-to.md#using-templates).

### pagy_bulma_nav_js(pagy, ...)

See the [Javascript Navs](../api/javascript.md#javascript-navs) documentation.

### pagy_bulma_combo_nav_js(pagy, ...)

![bulma_combo_nav_js](../assets/images/bulma_combo_nav_js-g.png)

See the [Javascript Combo Navs](../api/javascript.md#javascript-combo-navs) documentation.
