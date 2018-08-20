---
title: Bootstrap
---
# Bootstrap Extra

This extra adds nav helpers and templates for Bootstrap pagination.

## Synopsys

See [extras](../extras.md) for general usage info.

In the `pagy.rb` initializer:

```ruby
require 'pagy/extras/bootstrap'
```

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_bootstrap(@pagy) %>
<%== pagy_nav_responsive_bootstrap(@pagy) %>
<%== pagy_nav_compact_bootstrap(@pagy) %>
```

or with a template:

```erb
<%== render 'pagy/nav_bootstrap', locals: {pagy: @pagy} %>
```

Configure [javascript](../extras.md#javascript) if you use `pagy_nav_responsive_bootstrap` or `pagy_nav_compact_bootstrap`.

## Files

This extra is composed of 4 files:

- [bootstrap.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/bootstrap.rb)
- [nav_bootstrap.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bootstrap.html.erb) (optional template)
- [nav_bootstrap.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bootstrap.html.haml) (optional template)
- [nav_bootstrap.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_bootstrap.html.slim)  (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize them by overriding it directly in your own view helper.

### pagy_nav_bootstrap(pagy)

This method is the same as the `pagy_nav`, but customized for Bootstrap.

The `nav_bootstrap.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

### pagy_nav_compact_bootstrap(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for the Bootstrap framework.

Here is an example:

![pagy-compact](../assets/images/pagy-compact-g.png)

See more details in the [compact navs](navs.md#compact-navs) documentation.

### pagy_nav_responsive_bootstrap(pagy, ...)

This method is the same as the `pagy_nav_responsive`, but customized for the Bootstrap framework.

See more details in the [responsive navs](navs.md#responsive-navs) documentation.

### Optional Template Files

See [Using Templates](../how-to.md#using-templates).
