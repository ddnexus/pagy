---
title: Foundation
---
# Foundation Extra

This extra adds nav helper and templates for the Foundation [pagination component](https://foundation.zurb.com/sites/docs/pagination.html).

## Synopsys

See [extras](../extras.md) for general usage info.

Render the navigation links in some view...
with a fast helper:

```erb
<%== pagy_nav_foundation(@pagy) %>
```

or with a template:

```erb
<%== render 'pagy/nav_foundation', locals: {pagy: @pagy} %>
```

Configure [javascript](../extras.md#javascript) if you use `pagy_nav_responsive_foundation` or `pagy_nav_compact_foundation`.

## Files

This extra is composed of 4 files:

- [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb)
- [nav_foundation.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_foundation.html.erb) (optional template)
- [nav_foundation.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_foundation.html.haml) (optional template)
- [nav_foundation.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/templates/nav_foundation.html.slim)  (optional template)

## Methods

This extra adds 3 nav helpers to the `Pagy::Frontend` module. You can customize it by overriding it directly in your own view helper.

### pagy_nav_foundation(pagy)

This method is the same as the `pagy_nav`, but customized for Foundation.

The `nav_foundation.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

### pagy_nav_compact_foundation(pagy, ...)

This method is the same as the `pagy_nav_compact`, but customized for the Foundation framework.

See more details in the [compact navs](navs.md#compact-navs) documentation.

### pagy_nav_responsive_foundation(pagy, ...)

This method is the same as the `pagy_nav_responsive`, but customized for the Foundation framework.

See more details in the [responsive navs](navs.md#responsive-navs) documentation.

### Optional Template Files

See [Using Templates](../how-to.md#using-templates).
