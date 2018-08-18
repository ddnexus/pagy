---
title: Foundation
---
# Foundation Extra

This extra adds nav helper and templates for Foundation pagination.

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

## Files

This extra is composed of 4 files:

- [foundation.rb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/foundation.rb)
- [nav_foundation.html.erb](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/templates/nav_foundation.html.erb) (optional template)
- [nav_foundation.html.haml](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/templates/nav_foundation.html.haml) (optional template)
- [nav_foundation.html.slim](https://github.com/ddnexus/pagy/blob/master/lib/pagy/extras/templates/nav_foundation.html.slim)  (optional template)

## Methods

This extra adds one nav helpers to the `Pagy::Frontend` module. You can customize it by overriding it directly in your own view helper.

### pagy_nav_foundation(pagy)

This method is the same as the `pagy_nav`, but customized for Foundation.

The `nav_foundation.*` templates produce the same output, and can be used as an easier (but slower) starting point to override it.

### Optional Template Files

See [Using Templates](../how-to.md#using-templates).
