---
title: Bootstrap
category: Frontend Extras
image: null
---
# Bootstrap Extra

This extra adds nav helpers and templates for the Bootstrap [pagination component](https://getbootstrap.com/docs/4.1/components/pagination).

## Synopsis

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/bootstrap'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_bootstrap_nav(@pagy, ...) %>
<%== pagy_bootstrap_nav_js(@pagy, ...) %>
<%== pagy_bootstrap_combo_nav_js(@pagy, ...) %>
```

or with a template:

```erb
<%== render partial: 'pagy/bootstrap_nav', locals: {pagy: @pagy} %>
```

See [Javascript](../api/javascript.md) if you use `pagy_bootstrap_nav_js` or `pagy_bootstrap_combo_nav_js`.

## Files

- [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb)
- [bootstrap_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.erb) (optional template)
- [bootstrap_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.haml) (optional template)
- [bootstrap_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.slim) (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by direct overriding in your own view helper.

### pagy_bootstrap_nav(pagy, ...)

This method is the same as the `pagy_nav`, but customized for Bootstrap.

See the [pagy_nav(pagy, ...)](../api/frontend.md#pagy_navpagy-) documentation.

The `bootstrap_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it. See [How to use templates](../how-to.md#use-templates).

### pagy_bootstrap_nav_js(pagy, ...)

See the [Javascript Navs](../api/javascript.md#javascript-navs) documentation.

### pagy_bootstrap_combo_nav_js(pagy, ...)

![bootstrap_combo_nav_js](../assets/images/bootstrap_combo_nav_js-g.png)

See the [Javascript Combo Navs](../api/javascript.md#javascript-combo-navs) documentation.
