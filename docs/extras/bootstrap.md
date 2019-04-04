---
title: Bootstrap
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
<%== pagy_bootstrap_nav(@pagy) %>
<%== pagy_bootstrap_nav_js(@pagy) %>
<%== pagy_bootstrap_compact_nav_js(@pagy) %>
```

or with a template:

```erb
<%== render 'pagy/bootstrap_nav', locals: {pagy: @pagy} %>
```

Configure [javascript](../extras.md#javascript) if you use `pagy_bootstrap_nav_js` or `pagy_bootstrap_compact_nav_js`.

## Files

- [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb)
- [bootstrap_nav.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.erb) (optional template)
- [bootstrap_nav.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.haml) (optional template)
- [bootstrap_nav.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/bootstrap_nav.html.slim) (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding them directly in your own view helper.

### pagy_bootstrap_nav(pagy)

This method is the same as the `pagy_nav`/`pagy_plain_nav`, but customized for Bootstrap.

The `bootstrap_nav.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

### pagy_bootstrap_compact_nav_js(pagy, ...)

This method is the same as the `pagy_plain_compact_nav_js`, but customized for the Bootstrap framework.

Here is an example:

![pagy-compact](../assets/images/pagy-compact-g.png)

See more details in the [compact navs](plain.md#compact-navs) documentation.

### pagy_bootstrap_nav_js(pagy, ...)

This method is the same as the `pagy_plain_nav_js`, but customized for the Bootstrap framework.

See more details in the [responsive navs](plain.md#responsive-navs) documentation.

### Optional Template Files

See [Using Templates](../how-to.md#using-templates).
